require "spec_helper"

RSpec.describe LineReportsHelper, type: :helper do
  let(:user) { create(:user) }

  describe "#line_report_status" do
    it "returns 'Pending requests' if the user has pending annual leave requests" do
      create(:annual_leave_request, user_id: user.id, status: "pending")

      output = helper.line_report_status(user)

      expect(output).to eq(sanitize("<strong class='govuk-tag govuk-tag--red'> Pending requests </strong>"))
    end

    it "returns 'No pending requests' it the user has no pending annual leave requests" do
      create(:annual_leave_request, user_id: user.id, status: "approved")

      output = helper.line_report_status(user)

      expect(output).to eq(sanitize("<strong class='govuk-tag govuk-tag--green'> No pending requests </strong>"))
    end
  end
end
