class RoundStart
  def start_round(round, participant)
    round.status = "in progress"
    round.round_prompt = GetPrompt.new.call_api
    round.current_prompt = round.round_prompt
    round.save

    participant.prompt = round.round_prompt
    participant.participant_type = "drawer"
    participant.save

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
