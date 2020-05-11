class Api::V1::DrawingsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    data_uri = drawing_params[:drawing]
    participant_id = Participant.where(user_id: drawing_params[:user_id]).where(round_id: drawing_params[:round_id])[0].id
    drawing = Drawing.create(drawing: data_uri, participant_id: participant_id)

    if drawing.save
      participant = Participant.find(participant_id)
      participant.response = "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # drawing.drawing.url # TODO: UPDATE ONCE AWS IS HOOKED UP
      if participant.save
        round = Round.find(drawing_params[:round_id])
        round.turn += 1
        round.current_prompt = "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg"
        if round.turn == round.participants.count
          round.status = "complete"
          if round.save
            render json: round, serializer: Api::V1::RoundShowSerializer
          else
            render json: { error: round.errors.full_messages }, status: :unprocessable_entity
          end
        else
          next_participant = Participant.where(round_id: round.id).order(:created_at).offset(round.turn)[0]
          round.turn_user_id = next_participant.user_id
          if round.save
            next_participant.prompt = "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # drawing.drawing.url # TODO: UPDATE ONCE AWS IS HOOKED UP
            next_participant.participant_type = "guesser"
            if next_participant.save
              render json: round, serializer: Api::V1::RoundShowSerializer
            else
              render json: { error: next_participant.errors.full_messages }, status: :unprocessable_entity
            end
          else
            render json: { error: round.errors.full_messages }, status: :unprocessable_entity
          end
        end
      else
        render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: drawing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def drawing_params
    params.require(:payload).permit(:drawing, :user_id, :round_id)
  end
end
