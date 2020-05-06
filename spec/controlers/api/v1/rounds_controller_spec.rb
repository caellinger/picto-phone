require "rails_helper"

RSpec.describe Api::V1::RoundsController, type: :controller do
  describe "GET#index" do
    let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
    let!(:round1) { Round.create(starter_name: "test_user_1", turn_user_id: user1.id) }
    let!(:round2) { Round.create(starter_name: "test_user_2", turn_user_id: user2.id) }

    it "returns a successful response status and a content type of json" do
      get :index

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
    end

    it "returns all rounds in the database" do
      get :index
      response_body = JSON.parse(response.body)

      expect(response_body.length).to eq 1
      expect(response_body["rounds"][0].length).to eq 3
      expect(response_body["rounds"][0]["starter_name"]).to eq round1.starter_name

      expect(response_body["rounds"][1]["starter_name"]).to eq round2.starter_name
    end

    it "returns current user information if user is logged in" do
      sign_in user1
      get :index
      response_body = JSON.parse(response.body)

      expect(response_body["rounds"][0]["current_user"].length).to eq 2
      expect(response_body["rounds"][0]["current_user"]["userName"]).to eq user1.user_name
    end

    it "returns nil user information if user is not logged in" do
      get :index
      response_body = JSON.parse(response.body)

      expect(response_body["rounds"][0]["current_user"].length).to eq 2
      expect(response_body["rounds"][0]["current_user"]["userName"]).to eq nil
    end
  end

  describe "POST#new" do
    let!(:user) { User.create(email: "test@email.com", user_name: "test_user_1", password: "password") }
    let!(:new_round) { {round: { starter_name: "test_user_1", turn_user_id: user.id } } }
    let!(:bad_round_1) { { round: { starter_name: "", turn_user_id: user.id } } }
    let!(:bad_round_2) { { round: { starter_name: nil, turn_user_id: user.id  } } }
    let!(:bad_round_3) { { round: { starter_name: "test_user_1", turn_user_id: "" } } }
    let!(:bad_round_4) { { round: { starter_name: "test_user_1", turn_user_id: nil } } }

    it "fails to create a new Podcast record for an unauthenticated user" do
      previous_count = Round.count
      post :create, params: new_round, format: :json
      new_count = Round.count

      expect(new_count).to eq(previous_count)
    end

    it "creates a new Round record for an authenticated user and returns the new Round as json" do
      sign_in user
      previous_count = Round.count
      post :create, params: new_round, format: :json
      response_body = JSON.parse(response.body)
      new_count = Round.count

      expect(new_count).to eq(previous_count + 1)
      expect(response_body["round"].length).to eq 8
      expect(response_body["round"]["starter_name"]).to eq user.user_name
    end

    it "does not create a new round and returns error if starter name is empty" do
      sign_in user
      previous_count = Round.count
      post :create, params: bad_round_1, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Starter name can't be blank"
    end

    it "does not create a new round and returns error if starter name is nil" do
      sign_in user
      previous_count = Round.count
      post :create, params: bad_round_2, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Starter name can't be blank"
    end

    it "does not create a new round and returns error if turn_user_id is empty" do
      sign_in user
      previous_count = Round.count
      post :create, params: bad_round_3, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Turn user can't be blank"
    end

    it "does not create a new round and returns error if turn_user_id is nil" do
      sign_in user
      previous_count = Round.count
      post :create, params: bad_round_4, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Turn user can't be blank"
    end
  end

  describe "GET#show" do
    let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
    let!(:user3) { User.create(email: "test3@email.com", user_name: "test_user_3", password: "password") }
    let!(:round1) { Round.create(starter_name: "test_user_1", turn_user_id: user1.id) }
    let!(:round2) { Round.create(starter_name: "test_user_2", turn_user_id: user2.id) }
    let!(:participant1) { Participant.create(round: round1, user: user1, participant_type: "drawer", round_starter: true) }
    let!(:participant2) { Participant.create(round: round1, user: user2, participant_type: "guesser", round_starter: false) }
    let!(:participant3) { Participant.create(round: round1, user: user3, participant_type: "guesser", round_starter: false) }

    it "returns a successful response status and a content type of json, information on specified round, participants of that round, the current_user, round status, and whose turn it is" do
      sign_in user1
      get :show, params: {id: round1.id}
      response_body = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
      expect(response_body.length).to eq 1
      expect(response_body["round"]["id"]).to eq round1.id
      expect(response_body["round"]["starter_name"]).to eq round1.starter_name
      expect(response_body["round"]["current_user"]["id"]).to eq user1.id
      expect(response_body["round"]["current_user"]["userName"]).to eq user1.user_name
      expect(response_body["round"]["participants"]["participants"][0]["id"]).to eq participant1.id
      expect(response_body["round"]["participants"]["participants"][0]["user_id"]).to eq user1.id
      expect(response_body["round"]["status"]).to eq "waiting"
      expect(response_body["round"]["turn"]).to eq 0
      expect(response_body["round"]["turn_user_id"]).to eq user1.id
    end
  end

  describe "PATCH#update" do
    let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
    let!(:round1) { Round.create(starter_name: "test_user_1", turn_user_id: user1.id) }
    let!(:participant1) { Participant.create(user_id: user1.id, round_id: round1.id, participant_type: "drawer", round_starter: true) }
    let!(:participant2) { Participant.create(user_id: user2.id, round_id: round1.id, participant_type: "guesser", round_starter: false) }

    it "updates status" do
      sign_in user1
      edit_json = { id: round1.id, round: { status: "in progress",  } }
      put :update, params: edit_json, format: :json

      expect(Round.find(round1.id).status).to eq "in progress"
    end

    it "increments turn and updates turn_user_id if parameter turn is true" do
      sign_in user1
      edit_json = { id: round1.id, round: { turn: true } }
      put :update, params: edit_json, format: :json

      expect(Round.find(round1.id).turn).to eq 1
      expect(Round.find(round1.id).turn_user_id).to eq user2.id
    end
  end
end
