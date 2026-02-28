class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :volunteer
  validates :message, :link, presence: true
end
