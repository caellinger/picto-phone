class Api::V1::ParticipantsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    if Round.find(create_participant_params[:round_id]).participants.count > 3
      render json: {
        rounds: Round.find_by_sql("
          select
            rounds.id,
            rounds.starter_name
          from rounds
          left join participants on rounds.id = participants.round_id
          where rounds.status like 'waiting'
          group by rounds.id
          having count(participants.id) < 4;"),
        join_error: "Too many players in that round, please choose another"
      }
    else
      if Participant.where(round_id: create_participant_params[:round_id]).where(user_id: create_participant_params[:user_id])[0]
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
  end

  private

  def create_participant_params
    params.require(:payload).permit(:round_id, :user_id, :round_starter)
  end
end
