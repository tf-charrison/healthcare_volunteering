class Message < ApplicationRecord
  # Each message belongs to an application (conversation context)
  belongs_to :application

  # Ensure sender is either a volunteer or an organisation
  validates :sender_type, inclusion: { in: %w[volunteer organisation] }

  # Ensure message body is present
  validates :body, presence: true
end