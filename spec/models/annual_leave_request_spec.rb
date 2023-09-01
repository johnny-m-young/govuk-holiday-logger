require "spec_helper"

RSpec.describe AnnualLeaveRequest, type: :model do
  it "doesn't let you request more annual leave than you have left" do
    user = create(:user, annual_leave_remaining: 0)
    invalid_request = build(:annual_leave_request, user_id: user.id)
    error_message = "Days required exceeds remaining annual leave. You have 0.0 days annual leave remaining"
    expect(invalid_request.valid?).to be false
    expect(invalid_request.errors.to_a).to include(error_message)
  end
end
