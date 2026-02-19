class OrganisationsController < ApplicationController
  before_action :authenticate_organisation!

  # GET /organisation_dashboard
  def dashboard
    @opportunities = current_organisation.opportunities
  end
end
