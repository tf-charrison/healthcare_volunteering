class Application < ApplicationRecord
  # Defines the possible statuses for an application using an integer-backed enum
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # Associations
  # Each application is submitted by a volunteer and belongs to an opportunity
  belongs_to :volunteer
  belongs_to :opportunity

  # An application can have many messages (conversation thread)
  # and many updates (status changes, notifications, etc.)
  has_many :messages, dependent: :destroy
  has_many :application_updates, dependent: :destroy

  # Prevent a volunteer from applying to the same opportunity more than once
  validates :volunteer_id, uniqueness: { scope: :opportunity_id }

  # Set a default status before the record is created
  before_create :set_default_status

  private

  # Ensures new applications start in a pending state if no status is provided
  def set_default_status
    self.status ||= "pending"
  end
end