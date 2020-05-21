class RoundChannel < ApplicationCable::Channel
  def subscribed
    stream_from "round_#{params[:round_id]}"
  end

  def unsubscribed
  end

  def receive(data)
    round = Round.find(params[:round_id])
    participant = round.participants.where(user_id: current_user.id)[0]

    if data["status"]
      round_start = RoundStart.new(round, data["status"], participant)
      round_start.update_status
      round_start.get_prompt

      # if round.save
        participant.participant_type = data["participant_type"]
        if participant.save
          round_json = {
            id: round.id,
            starterName: round.starter_name,
            status: round.status,
            turn: round.turn,
            turnUserID: round.turn_user_id,
            roundPrompt: round.round_prompt,
            currentPrompt: round.current_prompt
          }
          ActionCable.server.broadcast("round_#{params[:round_id]}", round_json)
        end
      # end
    end

    if data["guess"]
      participant.response = data["guess"]

      if participant.save
        round.current_prompt = data["guess"]
        round.turn += 1
        if round.turn == round.participants.count
          round.status = "complete"
          if round.save
            round_json = {
              id: round.id,
              starterName: round.starter_name,
              status: round.status,
              turn: round.turn,
              turnUserID: round.turn_user_id,
              roundPrompt: round.round_prompt,
              currentPrompt: round.current_prompt
            }
            ActionCable.server.broadcast("round_#{params[:round_id]}", round_json)
          end
        else
          next_participant = Participant.where(round_id: round.id).order(:created_at).offset(round.turn)[0]
          round.turn_user_id = next_participant.user_id
          if round.save
            next_participant.prompt = data["guess"]
            next_participant.participant_type = "drawer"
            if next_participant.save
              round_json = {
                id: round.id,
                starterName: round.starter_name,
                status: round.status,
                turn: round.turn,
                turnUserID: round.turn_user_id,
                roundPrompt: round.round_prompt,
                currentPrompt: round.current_prompt
              }
              ActionCable.server.broadcast("round_#{params[:round_id]}", round_json)
            end
          end
        end
      end
    end

    if data["drawing"]
      data_uri = data["drawing"]
      drawing = Drawing.create(drawing: data_uri, participant_id: participant.id)

      if drawing.save
        participant.response = drawing.drawing.url # "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # use the regular link instead of drawing.drawing.url if you aren't sending things up to AWS in dev
        if participant.save
          round.turn += 1
          round.current_prompt = drawing.drawing.url # "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # use the regular link instead of drawing.drawing.url if you aren't sending things up to AWS in dev
          if round.turn == round.participants.count
            round.status = "complete"
            if round.save
              round_json = {
                id: round.id,
                starterName: round.starter_name,
                status: round.status,
                turn: round.turn,
                turnUserID: round.turn_user_id,
                roundPrompt: round.round_prompt,
                currentPrompt: round.current_prompt
              }
              ActionCable.server.broadcast("round_#{params[:round_id]}", round_json)
            end
          else
            next_participant = Participant.where(round_id: round.id).order(:created_at).offset(round.turn)[0]
            round.turn_user_id = next_participant.user_id
            if round.save
              next_participant.prompt = drawing.drawing.url # "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # use the regular link instead of drawing.drawing.url if you aren't sending things up to AWS in dev
              next_participant.participant_type = "guesser"
              if next_participant.save
                round_json = {
                  id: round.id,
                  starterName: round.starter_name,
                  status: round.status,
                  turn: round.turn,
                  turnUserID: round.turn_user_id,
                  roundPrompt: round.round_prompt,
                  currentPrompt: round.current_prompt
                }
                ActionCable.server.broadcast("round_#{params[:round_id]}", round_json)
              end
            end
          end
        end
      end
    end
  end

  private
    def get_prompt
      url = "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun%2Cverb-intransitive&minCorpusCount=150000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=#{ENV["WORDNIK_API_KEY"]}"
      response = Faraday.get(url)

      prompt_result = JSON.parse(response.body)
    end
end
