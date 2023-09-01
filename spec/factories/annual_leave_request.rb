FactoryBot.define do
  factory(:annual_leave_request) do
    date_from { Time.zone.today + 7 }
    date_to { Time.zone.today + 14 }
    days_required { WorkingDaysCalculator.new(date_from, date_to).number_of_working_days }
  end
end
