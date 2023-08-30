# Bank holidays are determined both by law and by proclamation.
# Link to the legislation to determine bank holidays:
#  http://www.legislation.gov.uk/ukpga/1971/80/schedule/1
#  and
#  http://www.legislation.gov.uk/asp/2007/2/section/1
# Link to where to find proclamations of bank holidays:
#  https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial"
#  Holidays are announced there 6 months to one year in advance, between the months of May and July for the following year.

# The following code is adapted from:
# https://github.com/alphagov/frontend/blob/51ed21f978560449c3fd339f56b5bd060245d3a1/lib/bank_holiday_generator.rb

class BankHolidayGenerator
  def initialize(year)
    @year = year
    @bank_holidays = []
  end

  BANK_HOLIDAYS = [
    :new_years_day, # by proclamation
    :good_friday,   # by proclamation
    :easter_monday, # by proclamation
    :early_may,     # by proclamation
    :spring,
    :last_monday_august,
    :christmas,
    :boxing_day,
  ].freeze

  attr_reader :year, :bank_holidays

  def list_of_bank_holidays
    BANK_HOLIDAYS.each do |bank_holiday|
      send(bank_holiday)
    end
    bank_holidays
  end

private

  def add_bank_holiday(date)
    bank_holidays << date
  end

  def new_years_day
    date = Date.new(year, 1, 1)
    new_date = substitute_day(date)
    add_bank_holiday(new_date)
  end

  def good_friday
    date = easter - 2
    add_bank_holiday(date)
  end

  def easter_monday
    date = easter + 1
    add_bank_holiday(date)
  end

  def early_may
    date = first_monday_of_month(year, 5)
    add_bank_holiday(date)
  end

  def spring
    date = last_monday_of_month(year, 5)
    add_bank_holiday(date)
  end

  def last_monday_august
    date = last_monday_of_month(year, 8)
    add_bank_holiday(date)
  end

  def christmas
    date = Date.new(year, 12, 25)
    new_date = substitute_day_next_day_off(date)
    add_bank_holiday(new_date)
  end

  def boxing_day
    date = Date.new(year, 12, 26)
    new_date = substitute_day(date)
    add_bank_holiday(new_date)
  end

  # Date utilities

  def first_monday_of_month(year, month)
    Date.new(year, month, 1).upto(Date.new(year, month, -1)).find(&:monday?)
  end

  def last_monday_of_month(year, month)
    Date.new(year, month, -1).downto(0).find(&:monday?)
  end

  # The following code comes from:
  # https://github.com/alexdunae/holidays
  def easter
    a = year % 19
    b = year / 100
    c = year % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    month = (h + l - 7 * m + 114) / 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    Date.civil(year, month, day)
  end

  def substitute_day(date)
    if date.saturday?
      date += 2
    elsif date.sunday?
      date += 1
    end
    date
  end

  def substitute_day_next_day_off(date)
    if date.saturday?
      date += 3
    elsif date.sunday?
      date += 2
    end
    date
  end
end
