class Opportunity < ApplicationRecord
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  has_many :volunteers, through: :applications

  validates :title, :description, :location, presence: true

  scope :expiring_within, ->(days = 3) { where(expiry_date: Date.today..(Date.today + days)) }

  def match_score_for(volunteer)
    return 0 unless volunteer&.skills.present? && skills_required.present?

    volunteer_skills = volunteer.skills.downcase.split(",").map(&:strip)
    required_skills  = skills_required.downcase.split(",").map(&:strip)

    (volunteer_skills & required_skills).size
  end
end
