class ApplicationUpdate < ApplicationRecord
  # Each update belongs to a specific application
  belongs_to :application

  # Polymorphic association to track who created the update
  # Can be either a Volunteer or an Organisation (or other user types)
  belongs_to :user, polymorphic: true

  # Ensure every update has a message
  validates :message, presence: true
end