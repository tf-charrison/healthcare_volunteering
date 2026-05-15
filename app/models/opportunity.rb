class Opportunity < ApplicationRecord
  # An opportunity belongs to an organisation
  belongs_to :organisation

  # An opportunity can have many applications and volunteers through those applications
  has_many :applications, dependent: :destroy
  has_many :volunteers, through: :applications

  # Ensure key fields are present
  validates :title, :description, :location, presence: true

  # Scope to find opportunities expiring within a given number of days
  scope :expiring_within, ->(days = 3) { where(expiry_date: Date.today..(Date.today + days)) }

  # Calculates a simple match score based on overlapping skills
  def match_score_for(volunteer)
    return 0 unless volunteer&.skills.present? && skills_required.present?

    volunteer_skills = volunteer.skills.downcase.split(",").map(&:strip)
    required_skills  = skills_required.downcase.split(",").map(&:strip)

    (volunteer_skills & required_skills).size
  end
end