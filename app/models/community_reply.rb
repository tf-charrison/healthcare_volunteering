class CommunityReply < ApplicationRecord
  # Each reply belongs to a community post and the volunteer who wrote it
  belongs_to :community_post
  belongs_to :volunteer

  # Ensure reply content is not empty
  validates :content, presence: true
end