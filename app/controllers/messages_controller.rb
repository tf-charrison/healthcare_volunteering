class MessagesController < ApplicationController
  before_action :set_opportunity
  before_action :set_application
  before_action :authenticate_user!  # see note below

  def create
    @message = @application.messages.build(message_params)
    @message.sender_type = current_volunteer ? "volunteer" : "organisation"

    if @message.save
      redirect_to opportunity_application_path(@opportunity, @application), notice: "Message sent."
    else
      redirect_to opportunity_application_path(@opportunity, @application), alert: "Failed to send message."
    end
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def set_application
    @application = @opportunity.applications.find(params[:application_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end

  # Simple helper to allow either volunteer or organisation
  def authenticate_user!
    unless current_volunteer || current_organisation
      redirect_to root_path, alert: "You must be signed in."
    end
  end
end
