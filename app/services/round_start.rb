class RoundStart
  def start_round(round, participant)
    round.status = "in progress"
    round.round_prompt = GetPrompt.new.call_api
    round.current_prompt = round.round_prompt
    round.save

    participant.prompt = round.round_prompt
    participant.participant_type = "drawer"
    participant.save

    return RoundJson.new.return_round_info(round)
  end
end
