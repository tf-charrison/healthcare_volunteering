class CommunityLike < ApplicationRecord
  # A like belongs to a volunteer who created it
  belongs_to :volunteer

  # A like belongs to a specific community post
  belongs_to :community_post

  # Prevent a volunteer from liking the same post more than once
  validates :volunteer_id, uniqueness: { scope: :community_post_id }
end