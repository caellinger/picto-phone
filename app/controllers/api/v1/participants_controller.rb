class Api::V1::ParticipantsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    binding.pry
    if Participant.where(round_id: create_participant_params[:round_id]).where(user_id: create_participant_params[:user_id])[0]
      binding.pry
      render json: { round: Round.find(create_participant_params[:round_id]) }
    else
      participant = Participant.new(create_participant_params)
      if participant.save
        render json: { round: Round.find(participant.round_id) }
      else
        render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def create_participant_params
    params.require(:payload).permit(:round_id, :user_id, :round_starter)
  end
end
