class Api::V1::RoundsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  protect_from_forgery unless: -> { request.format.json? }

  def index
    render json: Round.all
  end

  def create
    round = Round.new( {
      starter_name: create_round_params[:starter_name],
      turn_user_id: create_round_params[:turn_user_id]
    } )

    if round.save
      participant =  Participant.new( {
        user_id: create_round_params[:user_id],
        round_starter: create_round_params[:round_starter],
        round_id: round.id
      } )

      if participant.save
        render json: {
          round: round,
          participant: participant
        }
      else
        render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: round.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: Round.find(params[:id]), serializer: Api::V1::RoundShowSerializer
  end

  def update
    round = Round.find(params[:id])

    if update_round_params[:status]
      round.status = update_round_params[:status]
    end

    # if update_round_params[:turn]
    #   round.turn += 1
    #   round.turn_user_id = Participant.order(:created_at).offset(round.turn).find_by(round_id: round.id).user_id
    # end

    if update_round_params[:participant_type]
      participant = round.participants.where(user_id: current_user.id)[0]
      participant.participant_type = update_round_params[:participant_type]
    end

    if update_round_params[:prompt]
      round.prompt = "elephant"
      participant.prompt = "elephant"
    end # TODO: REMOVE ONCE WORDS API IS CONNECTED

    round.save

    json = {
      status: round.status
    }

    render json: json
  end

  private

  def create_round_params
    params.require(:payload).permit(:starter_name, :turn_user_id, :user_id, :round_starter)
  end

  def update_round_params
    params.require(:payload).permit(:status, :participant_type, :prompt)
  end
end
