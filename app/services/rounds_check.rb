class RoundsCheck
  def in_progress_limit?
    if Round.where(updated_at: 30.minutes.ago..Float::INFINITY).count > 24
      return true
    else
      return false
    end
  end

  def joinable_rounds_list
    Round.where(status: "waiting").where(updated_at: 30.minutes.ago..Float::INFINITY).filter {|round| round.participants.count < 6}
  end
end
