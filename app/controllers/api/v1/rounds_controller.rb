class Api::V1::RoundsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def index
    render json: Round.all
  end
end
