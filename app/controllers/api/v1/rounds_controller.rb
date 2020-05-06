class Api::V1::RoundsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  protect_from_forgery unless: -> { request.format.json? }

  def index
    render json: Round.all
  end

  def create
    round = Round.new(create_round_params)
    if round.save
      render json: {round: round}
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

    if update_round_params[:turn]
      round.turn += 1
      round.turn_user_id = Participant.order(:created_at).offset(round.turn).find_by(round_id: round.id).user_id
    end

    round.save

    render json: {}, status: :no_content
  end

  private

  def create_round_params
    params.require(:round).permit(:starter_name, :turn_user_id)
  end

  def update_round_params
    params.require(:round).permit(:status, :turn)
  end
end
