class CommunityLikesController < ApplicationController
  # Ensure only signed-in volunteers can like posts
  before_action :authenticate_volunteer!

  def create
    # Find the community post being liked via the nested route parameter
    post = CommunityPost.find(params[:community_post_id])

    # Build a like associated with the post and the current volunteer
    # Validations on the model should prevent duplicate likes by the same volunteer
    like = post.community_likes.build(volunteer: current_volunteer)

    # Attempt to save the like (no exception handling here; relies on validations)
    like.save

    # Redirect back to the community posts listing after liking
    redirect_to community_posts_path
  end
end