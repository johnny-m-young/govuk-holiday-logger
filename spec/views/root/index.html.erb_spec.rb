require "spec_helper"

RSpec.describe "root/index", type: :view do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "when a user has annual leave requests" do
    it "renders each request in a card" do
      annual_leave_request = create(:annual_leave_request, user_id: user.id)
      assign(:annual_leave_requests, user.annual_leave_requests)

      render

      expect(rendered).to have_content(annual_leave_request.status.to_s)
      expect(rendered).to have_content(annual_leave_request.date_from.to_fs(:rfc822))
      expect(rendered).to have_content(annual_leave_request.date_to.to_fs(:rfc822))
      expect(rendered).to have_content(annual_leave_request.days_required.to_s)
    end

    it "renders the correct css tag for pending leave" do
      create(:annual_leave_request, user_id: user.id, status: "pending")
      assign(:annual_leave_requests, user.annual_leave_requests)

      render

      expect(rendered).to have_content("pending")
      expect(rendered).to have_css(".govuk-tag--yellow")
    end

    it "renders the correct css tag for approved leave" do
      create(:annual_leave_request, user_id: user.id, status: "approved")
      assign(:annual_leave_requests, user.annual_leave_requests)

      render

      expect(rendered).to have_content("approved")
      expect(rendered).to have_css(".govuk-tag--green")
    end

    it "renders the correct css tag for withdrawn leave" do
      create(:annual_leave_request, user_id: user.id, status: "withdrawn")
      assign(:annual_leave_requests, user.annual_leave_requests)

      render

      expect(rendered).to have_content("withdrawn")
      expect(rendered).to have_css(".govuk-tag--red")
    end

    it "renders the correct css tag for denied leave" do
      create(:annual_leave_request, user_id: user.id, status: "denied")
      assign(:annual_leave_requests, user.annual_leave_requests)

      render

      expect(rendered).to have_content("denied")
      expect(rendered).to have_css(".govuk-tag--red")
    end
  end
end
