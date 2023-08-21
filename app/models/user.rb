class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, format: { with: /\A[^@\s]+@digital.cabinet-office.gov.uk+\z/ }
  validates :given_name, presence: true
  validates :family_name, presence: true
  validates :password, length: { minimum: 8, message: "must be at least 8 characters long" }
end
