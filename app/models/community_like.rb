class CommunityLike < ApplicationRecord
  belongs_to :volunteer
  belongs_to :community_post

  validates :volunteer_id, uniqueness: { scope: :community_post_id }
end
