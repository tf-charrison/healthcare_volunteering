class CommunityPost < ApplicationRecord
  # A post is created by a volunteer
  belongs_to :volunteer

  # A post can have many replies and likes
  # These are removed if the post is deleted
  has_many :community_replies, dependent: :destroy
  has_many :community_likes, dependent: :destroy

  # Ensure a post always has content
  validates :content, presence: true
end