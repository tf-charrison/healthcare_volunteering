# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :application

  validates :sender_type, inclusion: { in: %w[volunteer organisation] }
  validates :body, presence: true
end
