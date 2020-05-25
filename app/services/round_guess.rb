class RoundGuess
  def log_guess(round, participant, guess)
    participant.response = guess
    participant.save

    round.current_prompt = guess
    round.turn += 1

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
      next_participant.prompt = guess
      next_participant.participant_type = "drawer"
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
