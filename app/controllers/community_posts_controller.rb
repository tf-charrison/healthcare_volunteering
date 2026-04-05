class CommunityPostsController < ApplicationController
  before_action :authenticate_volunteer!

  def index
    @posts = CommunityPost.includes(:volunteer, :community_replies).order(created_at: :desc)
    @post = CommunityPost.new
  end

  def create
    @post = current_volunteer.community_posts.build(post_params)

    if @post.save
      redirect_to community_posts_path, notice: "Post created!"
    else
      @posts = CommunityPost.order(created_at: :desc)
      render :index
    end
  end

  private

  def post_params
    params.require(:community_post).permit(:content)
  end
end