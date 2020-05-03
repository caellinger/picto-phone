class Api::V1::RoundsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  protect_from_forgery unless: -> { request.format.json? }

  def index
    render json: Round.all
  end

  def create
    round = Round.new(round_params)
    if round.save
      render json: {round: round}
    else
      render json: { error: round.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def round_params
    params.require(:round).permit(:starter_name)
  end
end
