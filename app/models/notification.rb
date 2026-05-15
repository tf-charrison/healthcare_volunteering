class Notification < ApplicationRecord
  # The recipient can be different types of models (polymorphic)
  belongs_to :recipient, polymorphic: true

  # Each notification is associated with a volunteer
  belongs_to :volunteer

  # Ensure required fields are present
  validates :message, :link, presence: true
end