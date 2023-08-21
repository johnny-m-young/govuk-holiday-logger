require "spec_helper"

RSpec.describe User, type: :model do
  it "accepts valid email address formats" do
    valid_email = described_class.new(
      email: "right_format@digital.cabinet-office.gov.uk",
      given_name: "John",
      family_name: "Smith",
      password: "password",
    )
    expect(valid_email.valid?).to be true
  end

  it "rejects email inputs that are not emails" do
    invalid_email = described_class.new(
      email: "wrong_format",
      given_name: "John",
      family_name: "Smith",
      password: "password",
    )
    expect(invalid_email.valid?).to be false
    expect(invalid_email.errors.first.full_message).to eq("Email is invalid")
  end

  it "rejects unsupported email domains" do
    invalid_domain = described_class.new(
      email: "invalid_domain@gmail.com",
      given_name: "John",
      family_name: "Smith",
      password: "password",
    )
    expect(invalid_domain.valid?).to be false
    expect(invalid_domain.errors.first.full_message).to eq("Email is invalid")
  end

  it "rejects passwords shorter than 8 characters" do
    short_password = described_class.new(
      email: "valid_email@digital.cabinet-office.gov.uk",
      given_name: "John",
      family_name: "Smith",
      password: "1234567",
    )
    expect(short_password.valid?).to be false
    expect(short_password.errors.first.full_message).to eq("Password must be at least 8 characters long")
  end
end
