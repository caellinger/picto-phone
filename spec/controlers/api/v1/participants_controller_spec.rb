require "rails_helper"

RSpec.describe Api::V1::ParticipantsController, type: :controller do
  describe "POST#new" do
    let!(:user_1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user_2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
    let!(:new_round) { Round.create(starter_name: "test_user", turn_user_id: user_1.id) }
    let!(:new_participant_1) { { participant: { user_id: user_1.id, round_id: new_round.id, participant_type: "drawer", round_starter: true } } }

    it "fails to create a new Participant record for an unauthenticated user" do
      previous_count = Participant.count
      post :create, params: new_participant_1, format: :json
      new_count = Participant.count

      expect(new_count).to eq(previous_count)
    end

    it "creates a new Participant record for an authenticated user and returns the new Participant as json" do
      sign_in user_1
      previous_count = Participant.count
      post :create, params: new_participant_1, format: :json
      response_body = JSON.parse(response.body)
      new_count = Participant.count

      expect(new_count).to eq(previous_count + 1)
      expect(response_body["participant"].length).to eq 7
      expect(response_body["participant"]["round_id"]).to eq new_round.id
      expect(response_body["participant"]["user_id"]).to eq user_1.id
      expect(response_body["participant"]["participant_type"]).to eq "drawer"
      expect(response_body["participant"]["round_starter"]).to eq true
    end

    context "when a malformed request is made" do
      let!(:bad_participant_1) { { participant: { round_id: new_round.id, participant_type: "drawer", round_starter: true } } }
      let!(:bad_participant_2) { { participant: { user_id: user_1.id, participant_type: "drawer", round_starter: true } } }
      let!(:bad_participant_3) { { participant: { user_id: user_1.id, round_id: new_round.id, round_starter: true } } }
      let!(:bad_participant_4) { { participant: { user_id: user_1.id, round_id: new_round.id, participant_type: "drawer" } } }

      it "does not create a new round and returns error if user_id is empty" do
        sign_in user_1
        previous_count = Round.count
        post :create, params: bad_participant_1, format: :json
        new_count = Round.count
        response_body = JSON.parse(response.body)

        expect(new_count).to eq previous_count
        expect(response_body["error"][0]).to eq "User can't be blank"
      end

      it "does not create a new round and returns error if round_id is empty" do
        sign_in user_1
        previous_count = Round.count
        post :create, params: bad_participant_2, format: :json
        new_count = Round.count
        response_body = JSON.parse(response.body)

        expect(new_count).to eq previous_count
        expect(response_body["error"][0]).to eq "Round can't be blank"
      end

      it "does not create a new round and returns error if participant_type is empty" do
        sign_in user_1
        previous_count = Round.count
        post :create, params: bad_participant_3, format: :json
        new_count = Round.count
        response_body = JSON.parse(response.body)

        expect(new_count).to eq previous_count
        expect(response_body["error"][0]).to eq "Participant type can't be blank"
      end
    end
  end
end
