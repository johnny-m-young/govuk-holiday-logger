RSpec.describe AnnualLeaveRequestsController do
  describe "POST create" do
    let(:user) { create(:user, line_manager_id: line_manager.id) }
    let(:line_manager) { create(:user, email: "line_manager@digital.cabinet-office.gov.uk") }
    let(:notify_fake_client) { instance_double(Notifications::Client, send_email: "FakeNotificationResponse") }

    setup do
      allow(Notifications::Client).to receive(:new).and_return(notify_fake_client)
      sign_in user
    end

    it "emails line manager and redirects to confirmation page if annual leave request valid" do
      valid_request = build(:annual_leave_request, user_id: user.id)
      new_request_email_hash = {
        email_address: line_manager.email,
        template_id: "1587d50b-c12e-4698-b10e-cf414de26f36",
        personalisation: {
          line_manager_name: "#{line_manager.given_name} #{line_manager.family_name}",
          name: "#{user.given_name} #{user.family_name}",
          date_from: valid_request.date_from.to_fs(:rfc822),
          date_to: valid_request.date_to.to_fs(:rfc822),
          days_required: valid_request.days_required,
        },
      }

      post :create, params: { annual_leave_request: {
        date_from: valid_request.date_from,
        date_to: valid_request.date_to,
        days_required: valid_request.days_required,
      } }

      expect(notify_fake_client).to have_received(:send_email).with(new_request_email_hash)
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
end
