class CommunityLikesController < ApplicationController
  before_action :authenticate_volunteer!

  def create
    post = CommunityPost.find(params[:community_post_id])

    like = post.community_likes.build(volunteer: current_volunteer)

    like.save # validation prevents duplicates

    redirect_to community_posts_path
  end
end