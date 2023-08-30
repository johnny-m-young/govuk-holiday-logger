require "spec_helper"

RSpec.describe BankHolidayGenerator do
  it "generates bank holidays correctly" do
    # Bank holidays in England and Wales for 2023
    expected_output = [
      Date.civil(2023, 1, 2),
      Date.civil(2023, 4, 7),
      Date.civil(2023, 4, 10),
      Date.civil(2023, 5, 1),
      Date.civil(2023, 5, 29),
      Date.civil(2023, 8, 28),
      Date.civil(2023, 12, 25),
      Date.civil(2023, 12, 26),
    ]
    output = described_class.new(2023).list_of_bank_holidays
    expect(output).to eq(expected_output)
  end
end
