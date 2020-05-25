require 'rails_helper'

describe RoundGuess do
  describe "#log_guess" do
    before(:each) do
      user_1 = User.create(user_name: "test_user_1", email: "test1@email.com", password: "password")
      user_2 = User.create(user_name: "test_user_2", email: "test2@email.com", password: "password")
      round = Round.create(starter_name: user_1.user_name, turn_user_id: user_1.id, status: "in progress")
    end

    it "sets the current participant's response, updates the round current_prompt, updates the next participant's prompt, and increments the turn_user_id if it isn't the last turn in the round" do
      round = Round.first
      participant_1 = Participant.create(round_id: round.id, user_id: User.first.id)
      participant_2 = Participant.create(round_id: round.id, user_id: User.second.id)
      RoundGuess.new.log_guess(round, participant_1, "elephant")

      expect(Participant.find(participant_1.id).response).to eq("elephant")
      expect(Participant.find(participant_2.id).prompt).to eq("elephant")
      expect(Round.find(round.id).current_prompt).to eq("elephant")
      expect(Round.find(round.id).turn_user_id).to eq(Participant.find(participant_2.id).user_id)

      expect(Round.first.status).to eq("in progress")
    end

    it "sets the current participant's response, updates the round current_prompt, and sets the round status to complete if it's the last turn in the round" do
      round = Round.first
      participant_2 = Participant.create(round_id: round.id, user_id: User.second.id)
      RoundGuess.new.log_guess(round, participant_2, "mouse")

      expect(Participant.find(participant_2.id).response).to eq("mouse")
      expect(Round.first.current_prompt).to eq("mouse")

      expect(Round.first.status).to eq("complete")
    end
  end
end
