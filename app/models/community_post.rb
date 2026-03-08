class CommunityPost < ApplicationRecord
  belongs_to :volunteer
  has_many :community_replies, dependent: :destroy
  validates :content, presence: true
  has_many :community_likes, dependent: :destroy
end
