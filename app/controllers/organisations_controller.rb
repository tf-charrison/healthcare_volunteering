class OrganisationsController < ApplicationController
  # Allow public access to browsing organisations and their opportunities
  # but restrict sensitive/dashboard actions to authenticated organisations
  before_action :authenticate_organisation!, except: [:index, :show, :opportunities]

  # GET /organisation_dashboard
  # Displays a dashboard view for the currently signed-in organisation,
  # including all opportunities they have created
  def dashboard
    @opportunities = current_organisation.opportunities
  end

  # GET /organisations
  # Lists all organisations with optional filtering by name (case-insensitive)
  def index
    @organisations = Organisation.all

    if params[:name].present?
      @organisations = @organisations.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end
  end

  # GET /organisations/:id/opportunities
  # Shows all opportunities belonging to a specific organisation,
  # with optional filtering by required skills
  def opportunities
    @organisation = Organisation.find(params[:id])
    @opportunities = @organisation.opportunities

    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  # GET /organisations/:id
  # Displays a single organisation along with its opportunities
  def show
    @organisation = Organisation.find(params[:id])
    @opportunities = @organisation.opportunities

    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  # GET /organisations/volunteers
  # Displays a filtered list of volunteers for organisation review
  def volunteers
    @volunteers = filtered_volunteers
  end

  # GET /organisations/export_volunteers
  # Exports filtered volunteer data as a CSV file for external use
  def export_volunteers
    volunteers = filtered_volunteers

    csv_data = CSV.generate(headers: true) do |csv|
      # Define CSV headers
      csv << ["Name", "Email", "Phone", "Skills", "Experience", "Availability", "CPR", "HIPAA", "Background"]

      # Populate CSV rows with volunteer data
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

    # Send the generated CSV file as a download
    send_data csv_data, filename: "volunteers-#{Date.today}.csv"
  end

  private

  # Shared filtering logic used by both volunteers listing and CSV export
  def filtered_volunteers
    volunteers = Volunteer.all

    # Filter by email (partial match, case-insensitive)
    volunteers = volunteers.where("LOWER(email) LIKE ?", "%#{params[:email].to_s.downcase}%") if params[:email].present?

    # Filter by specific volunteer ID if provided
    volunteers = volunteers.where(id: params[:id]) if params[:id].present?

    # Filter by skills (partial match)
    volunteers = volunteers.where("LOWER(skills) LIKE ?", "%#{params[:skill].to_s.downcase}%") if params[:skill].present?

    # Filter by experience (partial match)
    volunteers = volunteers.where("LOWER(experience) LIKE ?", "%#{params[:experience].to_s.downcase}%") if params[:experience].present?

    # Filter by availability (exact match)
    volunteers = volunteers.where(availability: params[:availability]) if params[:availability].present?

    # Compliance / certification boolean filters
    volunteers = volunteers.where(cpr_certified: true) if params[:cpr_certified] == "1"
    volunteers = volunteers.where(hipaa_trained: true) if params[:hipaa_trained] == "1"
    volunteers = volunteers.where(background_checked: true) if params[:background_checked] == "1"

    volunteers
  end
end