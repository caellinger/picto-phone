require 'rails_helper'

describe RoundStart do
  describe '#start_round' do
    user = User.create(user_name: "test_user_1", email: "test1@email.com", password: "password")
    round = Round.create(starter_name: "test_user_1", turn_user_id: 1)
    participant = Participant.create(user_id: user.id, round_id: round.id)

    it 'sets status to in progress, sets round and participant prompts, and sets participant type' do
      VCR.use_cassette('get_prompt_from_API') do
        RoundStart.new.start_round(round, participant)

        expect(round.status).to eq "in progress"
        expect(round.round_prompt).not_to be_nil
        expect(round.current_prompt).to eq(round.round_prompt)
        expect(participant.prompt).to eq(round.round_prompt)
      end
    end
  end
end
