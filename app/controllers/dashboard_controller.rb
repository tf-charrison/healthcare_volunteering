class DashboardController < ApplicationController
  # Ensure only authenticated volunteers can access the dashboard
  before_action :authenticate_volunteer!

  # GET /dashboard
  # Displays the volunteer dashboard with their submitted applications
  def index
    # Load the current volunteer's applications, including associated opportunities
    # Ordered by most recently created first
    @applications = current_volunteer.applications.includes(:opportunity).order(created_at: :desc)
  end
end