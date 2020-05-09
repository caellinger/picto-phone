class Api::V1::DrawersController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    drawer = Drawer.new(drawer_params)
    if participant.save
      render json: {participant: participant}
    else
      render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def drawer_params
    params.require(:drawer).permit(:participant_id)
  end
end

# TODO: is this file necessary? not using an api endpoint to create a drawer record...will I need it for updating drawer record after drawing is created?
