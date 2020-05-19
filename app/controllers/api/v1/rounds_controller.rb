class Api::V1::RoundsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  protect_from_forgery unless: -> { request.format.json? }

  def index
    rounds_check = RoundsCheck.new()

    if current_user
      user = {
        id: current_user.id,
        user_name: current_user.user_name
      }
    else
      user = {
        id: nil,
        user_name: nil
      }
    end

    capped = rounds_check.in_progress_limit?

    render json: {
      rounds: rounds_check.joinable_rounds_list,
      current_user: user,
      capped: capped
    }
  end

  def create
    rounds_check = RoundsCheck.new()

    if rounds_check.in_progress_limit
      render json: { busy: true }
    else
      round = Round.new(create_round_params)

      if round.save
        participant =  Participant.new({
          user_id: create_participant_params[:user_id],
          round_starter: create_participant_params[:round_starter],
          round_id: round.id
        })

        if participant.save
          render json: {
            round: round
          }
        else
          render json: { error: participant.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: round.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    render json: Round.find(params[:id]), serializer: Api::V1::RoundShowSerializer
  end

  def update
    round = Round.find(update_round_params[:round_id])
    participant = round.participants.where(user_id: current_user.id)[0]

    if update_round_params[:status]
      round.round_prompt = get_prompt["word"]
      round.current_prompt = round.round_prompt
      participant.prompt = round.round_prompt

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
  end

  private

  def create_round_params
    params.require(:payload).permit(:starter_name, :turn_user_id)
  end

  def create_participant_params
    params.require(:payload).permit(:user_id)
  end

  def update_round_params
    params.require(:payload).permit(:round_id, :status, :participant_type, :prompt, :guess)
  end

  def get_prompt
    url = "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun%2Cverb-intransitive&minCorpusCount=150000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=#{ENV["WORDNIK_API_KEY"]}"
    response = Faraday.get(url)

    prompt_result = JSON.parse(response.body)
  end
end
