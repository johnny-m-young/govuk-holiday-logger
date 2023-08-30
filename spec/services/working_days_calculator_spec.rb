require "spec_helper"

RSpec.describe WorkingDaysCalculator, type: :model do
  describe "#number_of_working_days" do
    context "when annual leave is contained within the same year" do
      it "omits weekends" do
        # Dates including a non-bank holiday weekend
        date_from = Date.civil(2023, 8, 9)
        date_to = Date.civil(2023, 8, 14)
        expected_output = 4
        output = described_class.new(date_from, date_to).number_of_working_days
        expect(output).to eq(expected_output)
      end

      it "omits bank holidays" do
        # Mid-week dates including 28th August bank holiday (no weekend days)
        date_from = Date.civil(2023, 8, 28)
        date_to = Date.civil(2023, 9, 1)
        expected_output = 4
        output = described_class.new(date_from, date_to).number_of_working_days
        expect(output).to eq(expected_output)
      end
    end

    context "when annual leave spans multiple years" do
      it "omits bank holidays from both years" do
        # Dates spanning Christmas and New Years bank holidays
        date_from = Date.civil(2023, 12, 25)
        date_to = Date.civil(2024, 1, 5)
        expected_output = 7
        output = described_class.new(date_from, date_to).number_of_working_days
        expect(output).to eq(expected_output)
      end
    end
  end
end
