class Organisation < ApplicationRecord
  # Devise modules for authentication and account management, including two-factor auth
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         otp_secret_encryption_key: Rails.application.credentials.otp_secret_key

  # An organisation can create many opportunities
  has_many :opportunities, dependent: :destroy

  # Organisations can receive notifications (polymorphic association)
  has_many :notifications, as: :recipient, dependent: :destroy
end