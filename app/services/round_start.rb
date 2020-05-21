class RoundStart
  def initialize(round, status, participant)
    @round = round
    @status = status
    @participant = participant
  end

  def update_status
    @round.status = @status
  end

  def get_prompt
    get_prompt = GetPrompt.new
    @round.round_prompt = get_prompt.call_api
    @round.current_prompt = @round.round_prompt
    @participant.prompt = @round.round_prompt
  end
end
