class InsightsController < ApplicationController
  # Restrict access to organisation users only (insights are admin/organisation-facing)
  before_action :authenticate_organisation!

  def index
    # Total number of volunteers in the system
    @total_volunteers = Volunteer.count

    # Volunteers considered "active" if they have updated their record within the last 30 days
    @active_volunteers = Volunteer.where('updated_at >= ?', 30.days.ago).count

    # Total number of opportunities created
    @total_opportunities = Opportunity.count

    # Opportunities that have at least one application (matched to volunteers)
    @matched_opportunities = Opportunity.joins(:applications).distinct.count

    # Opportunities that have not received any applications
    @unmatched_opportunities = @total_opportunities - @matched_opportunities

    # Total number of applications marked as completed
    @completed_tasks = Application.where(status: 'completed').count

    # Daily volunteer signups over the past 30 days
    # Grouped by date for use in charts/visualisations
    @volunteer_signups = Volunteer
      .where('created_at >= ?', 30.days.ago)
      .group("DATE(created_at)")
      .count
  end
end