class AddAnnualLeaveRemainingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :annual_leave_remaining, :decimal, precision: 3, scale: 1, null: false, default: 25
  end
end
