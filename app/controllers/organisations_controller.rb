class OrganisationsController < ApplicationController
  before_action :authenticate_organisation!, except: [:index, :show, :opportunities]  # allow public access to index/show

  # GET /organisation_dashboard
  def dashboard
    @opportunities = current_organisation.opportunities
  end

  # GET /organisations
  def index
    @organisations = Organisation.all
    if params[:name].present?
      @organisations = @organisations.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end
  end

  def opportunities
    @organisation = Organisation.find(params[:id])
    @opportunities = @organisation.opportunities

    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  # GET /organisations/:id
  def show
    @organisation = Organisation.find(params[:id])
    @opportunities = @organisation.opportunities
    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  # GET /organisations/volunteers
  def volunteers
    @volunteers = filtered_volunteers
  end

  # GET /organisations/export_volunteers
  def export_volunteers
    volunteers = filtered_volunteers

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Name", "Email", "Phone", "Skills", "Experience", "Availability", "CPR", "HIPAA", "Background"]

      volunteers.find_each do |v|
        csv << [
          "#{v.first_name} #{v.last_name}",
          v.email,
          v.phone_number,
          v.skills,
          v.experience,
          v.availability,
          v.cpr_certified ? "✔️" : "✖️",
          v.hipaa_trained ? "✔️" : "✖️",
          v.background_checked ? "✔️" : "✖️"
        ]
      end
    end

    send_data csv_data, filename: "volunteers-#{Date.today}.csv"
  end

  private

  # DRY: filter logic shared between index and export
  def filtered_volunteers
    volunteers = Volunteer.all

    # Quick Lookup by email or ID
    volunteers = volunteers.where("LOWER(email) LIKE ?", "%#{params[:email].to_s.downcase}%") if params[:email].present?
    volunteers = volunteers.where(id: params[:id]) if params[:id].present?

    # Existing filters
    volunteers = volunteers.where("LOWER(skills) LIKE ?", "%#{params[:skill].to_s.downcase}%") if params[:skill].present?
    volunteers = volunteers.where("LOWER(experience) LIKE ?", "%#{params[:experience].to_s.downcase}%") if params[:experience].present?
    volunteers = volunteers.where(availability: params[:availability]) if params[:availability].present?

    # Boolean filters for certifications / compliance
    volunteers = volunteers.where(cpr_certified: true) if params[:cpr_certified] == "1"
    volunteers = volunteers.where(hipaa_trained: true) if params[:hipaa_trained] == "1"
    volunteers = volunteers.where(background_checked: true) if params[:background_checked] == "1"

    volunteers
  end
end