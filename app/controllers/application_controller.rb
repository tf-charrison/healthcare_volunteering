class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_volunteer, :volunteer_signed_in?, :current_organisation, :organisation_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_expiring_opportunities  # <--- ADD THIS
  before_action :fetch_notifications

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
  # Fetch opportunities expiring today or in the next 2 days for in-app alerts
  def set_expiring_opportunities
    return unless volunteer_signed_in?

    @expiring_opportunities = Opportunity
      .where(expiry_date: Date.today..(Date.today + 2.days))
      .order(:expiry_date)
  end

  def fetch_notifications
    if volunteer_signed_in?
      @notifications = current_volunteer.notifications.where(read: false).order(created_at: :desc)
    elsif organisation_signed_in?
      @notifications = current_organisation.notifications.where(read: false).order(created_at: :desc)
    end
  end
end
