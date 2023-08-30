class WorkingDaysCalculator
  attr_reader :date_from, :date_to

  def initialize(date_from, date_to)
    @date_from = date_from
    @date_to = date_to
  end

  def number_of_working_days
    calendar.business_days_between(date_from, date_to + 1)
  end

  def bank_holidays
    if date_from.year != date_to.year
      BankHolidayGenerator.new(date_from.year).list_of_bank_holidays +
        BankHolidayGenerator.new(date_to.year).list_of_bank_holidays
    else
      BankHolidayGenerator.new(date_from.year).list_of_bank_holidays
    end
  end

  def calendar
    @calendar ||= Business::Calendar.new(holidays: bank_holidays)
  end
end
