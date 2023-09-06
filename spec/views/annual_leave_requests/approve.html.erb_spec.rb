require "spec_helper"

RSpec.describe "annual_leave_requests/approve", type: :view do
  let(:user) { create(:user) }

  context "when there are errors present" do
    it "renders the error summary" do
      invalid_leave_request = create(:annual_leave_request, user_id: user.id)
      invalid_leave_request.errors.add(:date_from, "error 1")
      assign(:annual_leave_request, invalid_leave_request)

      render

      expect(rendered).to have_content("Fix the following issue(s) and re-submit your request")
    end
  end

  context "when there are no errors present" do
    it "doesn't render the error summary" do
      assign(:annual_leave_request, create(
                                      :annual_leave_request,
                                      user_id: user.id,
                                    ))

      render

      expect(rendered).not_to have_content("Fix the following issue(s) and re-submit your request")
    end
  end
end
