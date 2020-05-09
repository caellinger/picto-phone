class Api::V1::DrawingsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def show
    render json: Drawing.find(params[:id])
  end

  def create
    data_uri = params[:drawing]
    drawer_id = Participant.where(user_id: params[:user][:id]).where(round_id: params[:round][:id])[0].drawers[0].id
    drawing = Drawing.create(drawing: data_uri, drawer_id: drawer_id)
    binding.pry
    if drawing.save
    else
      render json: { error: drawing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def drawing_params
    params.require(:drawing).permit(:drawer_id, :drawing)
  end # TODO: Figure out how to implement strong params. Getting "undefined method 'permit' for String..."
end
