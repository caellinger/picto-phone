class RoundChannel < ApplicationCable::Channel
  def subscribed
    stream_from "round_#{params[:round_id]}"
  end

  def unsubscribed
  end

  def receive(data)
    round = Round.find(params[:round_id])
    participant = round.participants.where(user_id: current_user.id)[0]

    if data["start"]
      broadcast = RoundStart.new.start_round(round, participant)

      ActionCable.server.broadcast("round_#{params[:round_id]}", broadcast)
    end

    if data["guess"]
      broadcast = RoundGuess.new.log_guess(round, participant, data["guess"])

      ActionCable.server.broadcast("round_#{params[:round_id]}", broadcast)
    end

    if data["drawing"]
      broadcast = RoundDrawing.new.log_drawing(round, participant, data["drawing"])

      ActionCable.server.broadcast("round_#{params[:round_id]}", broadcast)
    end
  end
end
