class CreateAnnualLeaveRequest < ActiveRecord::Migration[7.0]
  def change
    create_table :annual_leave_requests do |t|
      t.string :status, default: "pending"
      t.date :date_from
      t.date :date_to
      t.decimal :days_required
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
