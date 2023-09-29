RSpec.describe AnnualLeaveRequestsController do
  let(:user) { create(:user, line_manager_id: line_manager.id) }
  let(:user_full_name) { "#{user.given_name} #{user.family_name}" }
  let(:line_manager) { create(:user, email: "line_manager@digital.cabinet-office.gov.uk") }
  let(:notify_test_client) { Notifications::Client.new(ENV["NOTIFY_TEST_API_KEY"]) }

  describe "POST create" do
    setup do
      allow(controller).to receive(:notify_client).and_return(notify_test_client)
      sign_in user
    end

    it "emails line manager and redirects to confirmation page if annual leave request valid" do
      valid_request = build(:annual_leave_request, user_id: user.id)

      post :create, params: { annual_leave_request: {
        date_from: valid_request.date_from,
        date_to: valid_request.date_to,
        days_required: valid_request.days_required,
      } }

      email_response_notification = assigns(:email_response_notification)
      email_response = notify_test_client.get_notification(email_response_notification.id)

      expect(email_response.email_address).to eq(line_manager.email)
      expect(email_response.subject).to eq("GOV.UK Holiday Logger – #{user_full_name} – New Annual Leave Request")
      expect(response).to redirect_to(annual_leave_request_confirmation_path)
    end

    it "redirects to new page if annual leave request invalid" do
      invalid_request = build(:annual_leave_request, user_id: user.id, date_to: Time.zone.today - 1)
      post :create, params: { annual_leave_request: {
        date_from: invalid_request.date_from,
        date_to: invalid_request.date_to,
        days_required: invalid_request.days_required,
      } }
      expect(response).to render_template(:new)
    end
  end

  describe "PATCH update_status" do
    let(:leave_request) { create(:annual_leave_request, user_id: user.id) }

    setup do
      allow(controller).to receive(:notify_client).and_return(notify_test_client)
      sign_in line_manager
    end

    it "renders the approve page if a status update to 'approved' is unsuccessful" do
      patch :update_status, params: {
        annual_leave_request_id: leave_request.id,
        annual_leave_request: {
          confirm_approval: "unconfirmed",
          status: "approved",
        },
      }

      expect(response).to render_template(:approve)
    end

    it "renders the deny page if a status update to 'denied' is unsuccessful" do
      patch :update_status, params: {
        annual_leave_request_id: leave_request.id,
        annual_leave_request: {
          denial_reason: "",
          status: "denied",
        },
      }

      expect(response).to render_template(:deny)
    end

    it "sends an email to the line report and redirects to confirmatioon page when status is updated to 'approved'" do
      patch :update_status, params: {
        annual_leave_request_id: leave_request.id,
        annual_leave_request: {
          status: "approved",
          confirm_approval: "confirmed",
        },
      }

      email_response_notification = assigns(:email_response_notification)
      email_response = notify_test_client.get_notification(email_response_notification.id)

      expect(email_response.email_address).to eq(user.email)
      expect(email_response.subject).to eq("GOV.UK Holiday Logger – Annual Leave Request Approved")
      expect(response).to redirect_to(confirm_annual_leave_request_approval_path)
    end

    it "sends an email to the line report and redirects to confirmatioon page when status is updated to 'denied'" do
      patch :update_status, params: {
        annual_leave_request_id: leave_request.id,
        annual_leave_request: {
          status: "denied",
          denial_reason: "some valid reason",
        },
      }

      email_response_notification = assigns(:email_response_notification)
      email_response = notify_test_client.get_notification(email_response_notification.id)

      expect(email_response.email_address).to eq(user.email)
      expect(email_response.subject).to eq("GOV.UK Holiday Logger – Annual Leave Request Denied")
      expect(response).to redirect_to(confirm_annual_leave_request_denial_path)
    end
  end
end
