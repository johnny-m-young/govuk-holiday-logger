require "spec_helper"

RSpec.describe "line_reports/index", type: :view do
  let(:line_manager) { create(:user) }
  let(:line_report) { create(:user, line_manager_id: line_manager.id) }

  setup do
    sign_in line_manager
  end

  context "when a line report has pending annual leave requests" do
    it "the line report's status is 'Pending requests'" do
      create(:annual_leave_request, user_id: line_report.id, status: "pending")
      assign(:line_reports, line_manager.line_reports)

      render

      expect(rendered).to have_content("Pending requests")
      expect(rendered).to have_css(".govuk-tag--red")
    end
  end

  context "when a line report has no pending annual leave requests" do
    it "the line report's status is 'No pending requests'" do
      create(:annual_leave_request, user_id: line_report.id, status: "approved")
      assign(:line_reports, line_manager.line_reports)

      render

      expect(rendered).to have_content("No pending requests")
      expect(rendered).to have_css(".govuk-tag--green")
    end
  end
end
