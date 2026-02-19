class Opportunity < ApplicationRecord
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  has_many :volunteers, through: :applications

  validates :title, :description, :location, presence: true
end
