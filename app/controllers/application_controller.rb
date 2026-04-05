class ApplicationController < ActionController::Base
  # Restrict access to modern browsers with required feature support
  allow_browser versions: :modern

  # Make these methods available in views
  helper_method :current_volunteer, :volunteer_signed_in?, :current_organisation, :organisation_signed_in?

  # Run Devise parameter config for authentication actions
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Set opportunities that are about to expire (for alerts)
  before_action :set_expiring_opportunities

  # Load unread notifications for the current user
  before_action :fetch_notifications

  protected

  # Allow extra parameter (otp_attempt) during sign in
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  # Fetch opportunities expiring today or in the next 2 days
  def set_expiring_opportunities
    return unless volunteer_signed_in?

    @expiring_opportunities = Opportunity
      .where(expiry_date: Date.today..(Date.today + 2.days))
      .order(:expiry_date)
  end

  # Fetch unread notifications for volunteers or organisations
  def fetch_notifications
    if volunteer_signed_in?
      @notifications = current_volunteer.notifications.where(read: false).order(created_at: :desc)
    elsif organisation_signed_in?
      @notifications = current_organisation.notifications.where(read: false).order(created_at: :desc)
    end
  end
end