class Application < ApplicationRecord
  enum status: { pending: 0, approved: 1, rejected: 2 }

  belongs_to :volunteer
  belongs_to :opportunity
  has_many :messages, dependent: :destroy

  validates :volunteer_id, uniqueness: { scope: :opportunity_id }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end
