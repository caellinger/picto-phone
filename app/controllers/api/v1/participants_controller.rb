class Api::V1::ParticipantsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    participant = Participant.new(participant_params)
    if participant.save
      render json: {participant: participant}
    else
      render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:round_id, :user_id, :participant_type, :round_starter, :prompt, :response)
  end
end
