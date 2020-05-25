class RoundDrawing
  def log_drawing(round, participant, drawing_input)
    # data_uri = drawing_input
    drawing = Drawing.create(drawing: drawing_input, participant_id: participant.id)
    drawing.save

    participant.response = drawing.drawing.url # "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" # use the regular link instead of drawing.drawing.url if you aren't sending things up to AWS in dev
    participant.save

    round.turn += 1
    round.current_prompt = participant.response
    if round.turn == round.participants.count
      round.status = "complete"
      round.save

      return {
        id: round.id,
        starterName: round.starter_name,
        status: round.status,
        turn: round.turn,
        turnUserID: round.turn_user_id,
        roundPrompt: round.round_prompt,
        currentPrompt: round.current_prompt
      }
    else
      next_participant = Participant.where(round_id: round.id).order(:created_at).offset(round.turn)[0]
      next_participant.prompt = round.current_prompt
      next_participant.participant_type = "guesser"
      next_participant.save

      round.turn_user_id = next_participant.user_id
      round.save

      return {
        id: round.id,
        starterName: round.starter_name,
        status: round.status,
        turn: round.turn,
        turnUserID: round.turn_user_id,
        roundPrompt: round.round_prompt,
        currentPrompt: round.current_prompt
      }
    end
  end
end
