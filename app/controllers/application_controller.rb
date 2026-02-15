class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_volunteer, :volunteer_signed_in?, :current_organisation, :organisation_signed_in?
end
