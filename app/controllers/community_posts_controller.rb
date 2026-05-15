class CommunityPostsController < ApplicationController
  # Ensure only authenticated volunteers can access community posts
  before_action :authenticate_volunteer!

  # GET /community_posts
  # Displays a list of all community posts along with associated volunteers and replies
  # Also initializes a new post object for the creation form on the same page
  def index
    @posts = CommunityPost.includes(:volunteer, :community_replies).order(created_at: :desc)
    @post = CommunityPost.new
  end

  # POST /community_posts
  # Creates a new community post associated with the currently signed-in volunteer
  def create
    @post = current_volunteer.community_posts.build(post_params)

    if @post.save
      redirect_to community_posts_path, notice: "Post created!"
    else
      # Reload posts if validation fails so the index view can still render correctly
      @posts = CommunityPost.order(created_at: :desc)
      render :index
    end
  end

  private

  # Strong parameters for community posts
  # Only allows the content field to be submitted from the form
  def post_params
    params.require(:community_post).permit(:content)
  end
end