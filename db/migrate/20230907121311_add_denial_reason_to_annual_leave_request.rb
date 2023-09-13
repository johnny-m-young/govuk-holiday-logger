class AddDenialReasonToAnnualLeaveRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :annual_leave_requests, :denial_reason, :string, default: nil
  end
end
