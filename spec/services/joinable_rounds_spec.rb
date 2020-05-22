require 'rails_helper'

describe JoinableRounds do
  describe '#attempt_join_round' do
    before(:each) do
      Round.create(starter_name: "test1", turn_user_id: 1)
      User.create(user_name: "test1", email: "test1@email.com", password: "password")
    end

    it "returns the round as json if the user has previously joined the selected round, but does not create a new particpant record" do
      Participant.create(round_id: Round.first.id, user_id: User.first.id)
      previous_count = Participant.count
      returned_json = JoinableRounds.new.attempt_join_round(Round.first.id, User.first.id)
      new_count = Participant.count

      expect(returned_json[:round]).to eq Round.first
      expect(new_count).to eq previous_count
    end

    it "returns the round as json if the user was able to join the round" do
      previous_count = Participant.count
      returned_json = JoinableRounds.new.attempt_join_round(Round.first.id, User.first.id)
      new_count = Participant.count

      expect(returned_json[:round]).to eq Round.first
      expect(new_count).to eq previous_count + 1
    end

    it "returns joinable rounds if the selected round is full and the user has not previously joined the selected round" do
      Round.create(starter_name: "test1", turn_user_id: 1)
      User.create(user_name: "test2", email: "test2@email.com", password: "password")
      User.create(user_name: "test3", email: "test3@email.com", password: "password")
      User.create(user_name: "test4", email: "test4@email.com", password: "password")
      User.create(user_name: "test5", email: "test5@email.com", password: "password")
      User.create(user_name: "test6", email: "test6@email.com", password: "password")
      User.create(user_name: "test7", email: "test7@email.com", password: "password")
      Participant.create(round_id: Round.first.id, user_id: User.all[1].id)
      Participant.create(round_id: Round.first.id, user_id: User.all[2].id)
      Participant.create(round_id: Round.first.id, user_id: User.all[3].id)
      Participant.create(round_id: Round.first.id, user_id: User.all[4].id)
      Participant.create(round_id: Round.first.id, user_id: User.all[5].id)
      Participant.create(round_id: Round.first.id, user_id: User.all[6].id)
      returned_json = JoinableRounds.new.attempt_join_round(Round.first.id, User.first.id)

      expect(returned_json[:rounds].length).to eq 1
      expect(returned_json[:join_error]).to eq true
    end
  end
end
