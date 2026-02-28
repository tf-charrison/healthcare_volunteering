class ApplicationUpdate < ApplicationRecord
  belongs_to :application
  belongs_to :user, polymorphic: true # if you want to track who created the update
  validates :message, presence: true
end
