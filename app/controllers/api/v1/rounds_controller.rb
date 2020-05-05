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

  private

  def create_round_params
    params.require(:round).permit(:starter_name)
  end
end
