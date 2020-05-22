class JoinableRounds
  def attempt_join_round(round_id, user_id)
    if Participant.where(round_id: round_id).where(user_id: user_id)[0]
      return {
        round: Round.find(round_id)
      }
    elsif Round.find(round_id).participants.count > 5
      capped = RoundsCheck.new.in_progress_limit?
      return {
        rounds: RoundsCheck.new.joinable_rounds_list,
        capped: capped,
        join_error: true
      }
    else
      Participant.create(round_id: round_id, user_id: user_id)
      return {
        round: Round.find(round_id)
      }
    end
  end
end
