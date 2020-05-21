require 'rails_helper'
require_relative '../../app/services/rounds_check.rb'

describe RoundStart do
  describe '#start_round' do
    user = User.create(user_name: "test_user_1", email: "test1@email.com", password: "password")
    round = Round.create(starter_name: "test_user_1", turn_user_id: 1)
    participant = Participant.create(user_id: user.id, round_id: round.id)

    it 'sets status to in progress, sets round and participant prompts, and sets participant type' do
      RoundStart.new.start_round(round, participant)

      expect(round.status).to eq "in progress"
      expect(round.round_prompt).to eq "in progress" #what will this be after implementing VCR? just test for not null?
      expect(round.current_prompt) # same question
      expect(participant.prompt) # same question
    end
  end
end
