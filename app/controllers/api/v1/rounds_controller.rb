class Api::V1::RoundsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  protect_from_forgery unless: -> { request.format.json? }

  def index
    render json: Round.where(status: "waiting").order(:created_at).all
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
    round = Round.find(update_round_params[:round_id])
    participant = round.participants.where(user_id: current_user.id)[0]

    if update_round_params[:status]
        round.round_prompt = update_round_params[:prompt]
        round.current_prompt = update_round_params[:prompt]
        participant.prompt = update_round_params[:prompt]
        # TODO: REMOVE ONCE WORDS API IS CONNECTED

      round.status = update_round_params[:status]
      if round.save
        participant.participant_type = update_round_params[:participant_type]
        if participant.save
          render json: round, serializer: Api::V1::RoundShowSerializer
        else
          render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: round.errors.full_messages }, status: :unprocessable_entity
      end
    end
    #
    # if update_round_params[:participant_type]
    #   participant.participant_type = update_round_params[:participant_type]
    # end

    if update_round_params[:prompt]
      round.round_prompt = update_round_params[:prompt]
      round.current_prompt = update_round_params[:prompt]
      participant.prompt = update_round_params[:prompt]
    end # TODO: REMOVE ONCE WORDS API IS CONNECTED

    if update_round_params[:guess]
      participant.response = update_round_params[:guess]
      if participant.save
        round.current_prompt = update_round_params[:guess]
        round.turn += 1
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
            next_participant.prompt = update_round_params[:guess]
            next_participant.participant_type = "drawer"
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
    end

    # if round.save
    #   if participant.save
    #     render json: {
    #       round: round, serializer: Api::V1::RoundShowSerializer #,
    #       # participant: participant # TODO: IS THIS USED ANYWHERE?
    #     }
    #   else
    #     render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
    #   end
    # else
    #   render json: { error: round.errors.full_messages }, status: :unprocessable_entity
    # end
  end

  private

  def create_round_params
    params.require(:payload).permit(:starter_name, :turn_user_id, :user_id, :round_starter)
  end

  def update_round_params
    params.require(:payload).permit(:round_id, :status, :participant_type, :prompt, :guess)
  end
end
