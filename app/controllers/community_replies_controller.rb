class CommunityRepliesController < ApplicationController
  # Ensure only authenticated volunteers can create replies
  before_action :authenticate_volunteer!

  # POST /community_posts/:community_post_id/community_replies
  # Creates a reply associated with a specific community post and the current volunteer
  def create
    # Find the parent community post using the nested route parameter
    post = CommunityPost.find(params[:community_post_id])

    # Build a new reply associated with the post using permitted parameters
    reply = post.community_replies.build(reply_params)

    # Associate the reply with the currently signed-in volunteer
    reply.volunteer = current_volunteer

    if reply.save
      # On success, redirect back to the community posts page
      redirect_to community_posts_path
    else
      # On failure, redirect back with an error message
      redirect_to community_posts_path, alert: "Reply failed."
    end
  end

  private

  # Strong parameters for community replies
  # Only allows the content field to be submitted
  def reply_params
    params.require(:community_reply).permit(:content)
  end
end