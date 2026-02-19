class DashboardController < ApplicationController
  before_action :authenticate_volunteer!

  def index
    @applications = current_volunteer.applications.includes(:opportunity).order(created_at: :desc)
  end
end
