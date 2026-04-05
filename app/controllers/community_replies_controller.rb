class CommunityRepliesController < ApplicationController
  before_action :authenticate_volunteer!

  def create
    post = CommunityPost.find(params[:community_post_id])
    reply = post.community_replies.build(reply_params)
    reply.volunteer = current_volunteer

    if reply.save
      redirect_to community_posts_path
    else
      redirect_to community_posts_path, alert: "Reply failed."
    end
  end

  private

  def reply_params
    params.require(:community_reply).permit(:content)
  end
end