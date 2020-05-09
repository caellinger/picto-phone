require 'rails_helper'

RSpec.describe Api::V1::DrawingsController, type: :controller do
  describe "POST#new" do
    let!(:user_1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
    let!(:round) { Round.create(starter_name: "test_user", turn_user_id: user_1.id) }
    let!(:participant_1) { Participant.create(user_id: user_1.id, round_id: round.id, participant_type: "drawer", round_starter: true) }
    let!(:drawer_1) { Drawer.create(participant: participant_1)}
    let!(:new_drawing) { { drawer_id: drawer_1.id, drawing: { drawing: 'abc123', url: 'test.com'}, user: { id: user_1 }, round: { id: round } } }

    # it "creates a new Drawing record for an authenticated user" do
    #   sign_in user_1
    #   previous_count = Drawing.count
    #   new_json = {
    #     drawing: {"drawing"=>"data:image/jpeg;base64,/9j/4AAQSkZJ"},
    #     user: { id: user_1 },
    #     round: { id: round }
    #   }
    #   post :create, params: new_json, format: :json
    #   response_body = JSON.parse(response.body)
    #   new_count = Drawing.count
    #
    #   expect(new_count).to eq(previous_count + 1)
    # end # TODO: Why isn't it accepting the drawing as part of params?

    it "fails to create a new Drawing record for an unauthenticated user" do
      previous_count = Drawing.count
      new_json = {
        drawing: {"drawing"=>"data:image/jpeg;base64,/9j/4AAQSkZJ"},
        user: { id: user_1 },
        round: { id: round }
      }
      post :create, params: new_json, format: :json
      new_count = Drawing.count

      expect(new_count).to eq(previous_count)
    end

    it "does not create a new Drawing record and returns an error if drawing is nil" do
      sign_in user_1
      previous_count = Drawing.count
      new_json = {
        user: { id: user_1 },
        round: { id: round }
      }
      post :create, params: new_json, format: :json
      response_body = JSON.parse(response.body)
      new_count = Drawing.count

      expect(new_count).to eq(previous_count)
      expect(response_body["error"][0]).to eq "Drawing can't be blank"
    end

    it "does not create a new Drawing record and returns an error if user_id is nil" do
      sign_in user_1
      previous_count = Drawing.count
      new_json = {
        drawing: {"drawing"=>"data:image/jpeg;base64,/9j/4AAQSkZJ"},
        user: { id: nil },
        round: { id: round }
      }
      expect{ post :create, params: new_json, format: :json }.to raise_error(NoMethodError)
    end

    it "does not create a new Drawing record and returns an error if round_id is nil" do
      sign_in user_1
      previous_count = Drawing.count
      new_json = {
        drawing: {"drawing"=>"data:image/jpeg;base64,/9j/4AAQSkZJ"},
        user: { id: user_1 },
        round: { id: nil }
      }
      expect{ post :create, params: new_json, format: :json }.to raise_error(NoMethodError)
    end

    # it "updates the associated Drawer record with the drawing url" do
    # # TODO: Need to add this test once the drawing will save
    # end

  end
end
