class User < ApplicationRecord
  has_many :line_reports, class_name: "User", foreign_key: "line_manager_id"
  belongs_to :line_manager, class_name: "User", optional: true

  has_many :annual_leave_requests

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, format: { with: /\A[^@\s]+@digital.cabinet-office.gov.uk+\z/ }
  validates :given_name, :family_name, presence: true
  validates :password, length: { minimum: 8, message: "must be at least 8 characters long" }

  def is_line_manager?
    line_reports.any?
  end
end
