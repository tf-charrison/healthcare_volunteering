class Volunteer < ApplicationRecord
  # Devise modules for authentication and account management, including two-factor auth
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         otp_secret_encryption_key: Rails.application.credentials.otp_secret_key

  # A volunteer can submit many applications
  has_many :applications, dependent: :destroy

  # Opportunities the volunteer has applied to through applications
  has_many :applied_opportunities, through: :applications, source: :opportunity

  # Notifications received by the volunteer (polymorphic)
  has_many :notifications, as: :recipient, dependent: :destroy

  # Community interactions
  has_many :community_posts
  has_many :community_replies
  has_many :community_likes
end