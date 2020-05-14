require "rails_helper"

RSpec.describe Api::V1::RoundsController, type: :controller do
  describe "GET#index" do
    let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
    let!(:round1) { Round.create(starter_name: "test_user_1", turn_user_id: user1.id) }
    let!(:round2) { Round.create(starter_name: "test_user_2", turn_user_id: user2.id) }

    it "returns a successful response status and a content type of json" do
      sign_in user1
      get :index

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
    end

    it "returns all rounds in the database in order by created_at" do
      sign_in user1
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
    let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }

    it "fails to create a new Round record for an unauthenticated user" do
      previous_count = Round.count
      new_json = { payload: {
        starter_name: user1.user_name,
        turn_user_id: user1.id,
        user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: new_json, format: :json
      new_count = Round.count

      expect(new_count).to eq(previous_count)
    end

    it "fails to create a new Round record if there are already two rounds waiting or in progress and returns a busy message" do
      Round.create(starter_name: "test_user_1", turn_user_id: user1.id)
      Round.create(starter_name: "test_user_2", turn_user_id: user2.id)

      sign_in user1
      previous_count = Round.count
      new_json = { payload: {
        starter_name: user1.user_name,
        turn_user_id: user1.id,
        user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: new_json, format: :json
      response_body = JSON.parse(response.body)
      new_count = Round.count

      expect(new_count).to eq(previous_count)
      expect(response_body["busy"]).to eq(true)
    end

    it "creates a new Round record and Participant record for an authenticated user and returns the new Round as json" do
      sign_in user1
      previous_count = Round.count
      new_json = { payload: {
        starter_name: user1.user_name,
        turn_user_id: user1.id,
        user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: new_json, format: :json
      response_body = JSON.parse(response.body)
      new_count = Round.count

      expect(new_count).to eq(previous_count + 1)
      expect(response_body["round"].length).to eq 9
      expect(response_body["round"]["starter_name"]).to eq user1.user_name
    end

    it "does not create a new Round and returns error if starter name is empty" do
      sign_in user1
      previous_count = Round.count
      bad_json = { payload: {
        turn_user_id: user1.id,
        user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: bad_json, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Starter name can't be blank"
    end

    it "does not create a new Round and returns error if turn_user_id is empty" do
      sign_in user1
      previous_count = Round.count
      bad_json = { payload: {
        starter_name: user1.user_name,
        user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: bad_json, format: :json
      new_count = Round.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Turn user can't be blank"
    end

    it "does not create a new Participant and returns error if user_id is empty" do
      sign_in user1
      previous_count = Participant.count
      bad_json = { payload: {
        starter_name: user1.user_name,
        turn_user_id: user1.id,
        round_starter: true,
      } }
      post :create, params: bad_json, format: :json
      new_count = Participant.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "User can't be blank"
    end

    it "does not create a new Participant and returns error if round_starter is empty" do
      sign_in user1
      previous_count = Participant.count
      bad_json = { payload: {
        starter_name: user1.user_name,
        turn_user_id: user1.id,
        user_id: user1.id,
      } }
      post :create, params: bad_json, format: :json
      new_count = Participant.count
      response_body = JSON.parse(response.body)

      expect(new_count).to eq previous_count
      expect(response_body["error"][0]).to eq "Round starter is not included in the list"
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

  # describe "PATCH#update" do
  #   let!(:user1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
  #   let!(:user2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
  #   let!(:user3) { User.create(email: "test3@email.com", user_name: "test_user_3", password: "password") }
  #   let!(:round1) { Round.create(starter_name: "test_user_1", turn_user_id: user1.id) }
  #   let!(:participant1) { Participant.create(user_id: user1.id, round_id: round1.id, round_starter: true) }
  #   let!(:participant2) { Participant.create(user_id: user2.id, round_id: round1.id, round_starter: false) }
  #   let!(:round2) { Round.create(starter_name: "test_user_1", status: "in progress", turn: 1, turn_user_id: user2.id) }
  #   let!(:participant3) { Participant.create(user_id: user1.id, round_id: round2.id, round_starter: true) }
  #   let!(:participant4) { Participant.create(user_id: user2.id, round_id: round2.id, round_starter: false) }
  #   let!(:round3) { Round.create(starter_name: "test_user_1", status: "in progress", turn: 1, turn_user_id: user2.id) }
  #   let!(:participant5) { Participant.create(user_id: user1.id, round_id: round3.id, round_starter: true) }
  #   let!(:participant6) { Participant.create(user_id: user2.id, round_id: round3.id, round_starter: false) }
  #   let!(:round4) { Round.create(starter_name: "test_user_1", status: "in progress", turn: 1, turn_user_id: user2.id) }
  #   let!(:participant7) { Participant.create(user_id: user1.id, round_id: round4.id, round_starter: true) }
  #   let!(:participant8) { Participant.create(user_id: user2.id, round_id: round4.id, round_starter: false) }
  #   let!(:participant9) { Participant.create(user_id: user3.id, round_id: round4.id, round_starter: false) }
  #
  #   it "updates status and participant type when receiving a fetch request from the start button and returns round as json" do
  #     VCR.use_cassette('get_prompt_from_API') do
  #       sign_in user1
  #       edit_json = {
  #         id: round1.id,
  #         payload: {
  #           round_id: round1.id,
  #           status: "in progress",
  #           participant_type: "drawer"
  #         } }
  #       put :update, params: edit_json, format: :json
  #       response_body = JSON.parse(response.body)
  #
  #       expect(Round.find(round1.id).status).to eq "in progress"
  #       expect(Participant.find(participant1.id).participant_type).to eq "drawer"
  #       expect(response_body["round"].length).to eq 9
  #     end
  #   end
  #
  #   it "updates current participant with response and updates round with current_prompt and increments turn when receiving a fetch request from the submit guess button and returns round as json" do
  #     sign_in user2
  #     edit_json = {
  #       id: round2.id,
  #       payload: {
  #         round_id: round2.id,
  #         guess: "cat"
  #       } }
  #     put :update, params: edit_json, format: :json
  #     response_body = JSON.parse(response.body)
  #
  #     expect(Round.find(round2.id).turn).to eq 2
  #     expect(Round.find(round2.id).participants.where(user_id: user2.id)[0].response).to eq "cat"
  #     expect(Round.find(round2.id).current_prompt).to eq "cat"
  #     expect(response_body["round"].length).to eq 9
  #   end
  #
  #   it "updates the round status to complete when receiving a fetch request from the submit guess button if the current participant is the last turn" do
  #     sign_in user2
  #     edit_json = { id: round3.id, payload: { round_id: round3.id, guess: "cat" } }
  #     put :update, params: edit_json, format: :json
  #
  #     expect(Round.find(round3.id).status).to eq "complete"
  #   end
  #
  #   it "updates the next participant's type and prompt and updates rount turn_user_id when receiving a fetch request from the submit guess button if the current participant is not the last turn" do
  #     sign_in user2
  #     edit_json = { id: round4.id, payload: { round_id: round4.id, guess: "cat" } }
  #     put :update, params: edit_json, format: :json
  #
  #     expect(Round.find(round4.id).participants.where(user_id: user3.id)[0].participant_type).to eq "drawer"
  #     expect(Round.find(round4.id).participants.where(user_id: user3.id)[0].prompt).to eq "cat"
  #     expect(Round.find(round4.id).turn_user_id).to eq user3.id
  #   end
  # end
end
