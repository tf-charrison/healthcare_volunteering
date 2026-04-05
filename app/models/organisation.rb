class Organisation < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :two_factor_authenticatable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, otp_secret_encryption_key: Rails.application.credentials.otp_secret_key
  has_many :opportunities, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
end
