class RoundGuess
  def log_guess(round, participant, guess)
    participant.response = guess
    participant.save

    round.current_prompt = guess
    round.turn += 1

    if round.turn == round.participants.count
      round.status = "complete"
      round.save

      return RoundJson.new.return_round_info(round)
    else
      next_participant = Participant.where(round_id: round.id).order(:created_at).offset(round.turn)[0]
      next_participant.prompt = guess
      next_participant.participant_type = "drawer"
      next_participant.save

      round.turn_user_id = next_participant.user_id
      round.save

      return RoundJson.new.return_round_info(round)
    end
  end
end
