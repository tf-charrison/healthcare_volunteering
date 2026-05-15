class MessagesController < ApplicationController
  # Load the parent opportunity for nested routing
  before_action :set_opportunity

  # Load the specific application within the opportunity
  before_action :set_application

  # Allow access only if either a volunteer or organisation is signed in
  before_action :authenticate_user!

  # POST /opportunities/:opportunity_id/applications/:application_id/messages
  # Creates a new message associated with the application and identifies the sender type
  def create
    @message = @application.messages.build(message_params)

    # Determine whether the sender is a volunteer or an organisation
    # This assumes only one of these will be present at a time
    @message.sender_type = current_volunteer ? "volunteer" : "organisation"

    if @message.save
      # Redirect back to the application conversation view on success
      redirect_to opportunity_application_path(@opportunity, @application), notice: "Message sent."
    else
      # Redirect back with an error if the message fails validation
      redirect_to opportunity_application_path(@opportunity, @application), alert: "Failed to send message."
    end
  end

  private

  # Fetch the parent opportunity using the route parameter
  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  # Fetch the application scoped to the current opportunity
  def set_application
    @application = @opportunity.applications.find(params[:application_id])
  end

  # Strong parameters for message creation
  # Only allows the message body to be submitted
  def message_params
    params.require(:message).permit(:body)
  end

  # Custom authentication allowing either volunteers or organisations
  # Redirects to root if neither is signed in
  def authenticate_user!
    unless current_volunteer || current_organisation
      redirect_to root_path, alert: "You must be signed in."
    end
  end
end