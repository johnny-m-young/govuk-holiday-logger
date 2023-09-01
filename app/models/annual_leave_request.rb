class AnnualLeaveRequest < ApplicationRecord
  belongs_to :user

  validates :date_from, :date_to, :days_required, presence: true
  validates :date_from, comparison: { less_than: :date_to, message: "must be before Date to" }
  validates :date_from, :date_to, comparison: { greater_than: Time.zone.today, message: "must be in the future" }
  validate :user_has_enough_annual_leave_remaining

private

  def user_has_enough_annual_leave_remaining
    if user.annual_leave_remaining < days_required
      errors.add(
        :days_required,
        message: "exceeds remaining annual leave. You have #{user.annual_leave_remaining} days annual leave remaining",
      )
    end
  end
end
