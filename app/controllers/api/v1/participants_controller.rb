class Api::V1::ParticipantsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    render json: JoinableRounds.new.attempt_join_round(create_participant_params[:round_id], current_user.id)
  end

  private

  def create_participant_params
    params.require(:payload).permit(:round_id, :user_id, :round_starter)
  end
end
