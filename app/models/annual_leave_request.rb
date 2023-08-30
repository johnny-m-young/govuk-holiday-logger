class AnnualLeaveRequest < ApplicationRecord
  belongs_to :user

  validates :date_from, :date_to, :days_required, presence: true
  validates :date_from, comparison: { less_than: :date_to }
end
