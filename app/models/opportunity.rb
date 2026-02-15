class Opportunity < ApplicationRecord
  belongs_to :organisation

  validates :title, :description, :location, presence: true
end
