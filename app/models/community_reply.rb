class CommunityReply < ApplicationRecord
  belongs_to :community_post
  belongs_to :volunteer

  validates :content, presence: true
end
