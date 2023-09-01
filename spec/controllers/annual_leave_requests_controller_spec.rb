RSpec.describe AnnualLeaveRequestsController do
  describe "POST create" do
    let(:user) { create(:user) }

    setup do
      sign_in user
    end

    it "redirects to confirmation page if annual leave request valid" do
      valid_request = build(:annual_leave_request, user_id: user.id)
      post :create, params: { annual_leave_request: {
        date_from: valid_request.date_from,
        date_to: valid_request.date_to,
        days_required: valid_request.days_required,
      } }
      expect(response).to redirect_to(annual_leave_requests_confirmation_path)
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
