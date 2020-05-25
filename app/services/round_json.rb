class RoundJson
  def return_round_info(round)
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
