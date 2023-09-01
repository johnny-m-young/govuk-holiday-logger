require "spec_helper"

RSpec.describe ErrorsHelper, type: :helper do
  describe "#error_messages_for" do
    it "returns nil if there are no errors on instance" do
      valid_user = build(:user)

      output = helper.error_messages_for(valid_user)

      expect(output).to eq(nil)
    end

    it "returns a list of error messages for the instance" do
      invalid_user = build(:user)
      invalid_user.errors.add(:email, message: "error 1")
      invalid_user.errors.add(:given_name, message: "error 2")

      expected_output = [
        {
          href: "#user[:email]",
          text: "Email error 1",
        },
        {
          href: "#user[:given_name]",
          text: "Given name error 2",
        },
      ]
      output = helper.error_messages_for(invalid_user)

      expect(output).to eq(expected_output)
    end
  end

  describe "#error_message_for_input" do
    it "returns nil if no errors on attribute" do
      valid_user = build(:user)
      output = helper.error_message_for_input(valid_user.errors, :email)
      expect(output).to eq(nil)
    end

    it "returns a list of errors for the attribute" do
      invalid_user = build(:user)
      invalid_user.errors.add(:email, message: "error 1")
      invalid_user.errors.add(:email, message: "error 2")

      expected_output = "Email error 1<br>Email error 2"
      output = helper.error_message_for_input(invalid_user.errors, :email)

      expect(output).to eq(expected_output)
    end
  end
end
