require "spec_helper"

RSpec.describe EmailsHelper, type: :helper do
  let(:annual_leave_request) { create(:annual_leave_request, user_id: user.id) }
  let(:user) { create(:user, line_manager_id: line_manager.id) }
  let(:line_manager) { create(:user, email: "line_manager@digital.cabinet-office.gov.uk") }

  describe "#send_new_request_email" do
    it "sends an email to the users line manager" do
      @client = Notifications::Client.new(ENV["NOTIFY_TEST_API_KEY"])
      user_full_name = "#{user.given_name} #{user.family_name}"

      response_notification = helper.send_new_request_email(annual_leave_request)
      response = client.get_notification(response_notification.id)

      expect(response.email_address).to eq(line_manager.email)
      expect(response.subject).to eq("GOV.UK Holiday Logger – #{user_full_name} – New Annual Leave Request")
    end
  end

  describe "#send_approved_request_email" do
    it "sends an approval email to the user" do
      @client = Notifications::Client.new(ENV["NOTIFY_TEST_API_KEY"])

      response_notification = helper.send_approved_request_email(annual_leave_request)
      response = client.get_notification(response_notification.id)

      expect(response.email_address).to eq(user.email)
      expect(response.subject).to eq("GOV.UK Holiday Logger – Annual Leave Request Approved")
    end
  end

  describe "#send_denied_request_email" do
    it "sends a denial email to the user" do
      @client = Notifications::Client.new(ENV["NOTIFY_TEST_API_KEY"])
      annual_leave_request.denial_reason = "some reason"

      response_notification = helper.send_denied_request_email(annual_leave_request)
      response = client.get_notification(response_notification.id)

      expect(response.email_address).to eq(user.email)
      expect(response.subject).to eq("GOV.UK Holiday Logger – Annual Leave Request Denied")
    end
  end
end
