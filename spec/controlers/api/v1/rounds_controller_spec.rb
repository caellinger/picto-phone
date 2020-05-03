require "rails_helper"

RSpec.describe Api::V1::RoundsController, type: :controller do
  describe "GET#index" do
    let!(:user1) {User.create(email: "test@email.com", user_name: "test_user", password: "password")}
    let!(:round1) { Round.create(starter_name: "Christie1") }
    let!(:round2) { Round.create(starter_name: "Christie2") }

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
      binding.pry

      expect(response_body["rounds"][0]["user"].length).to eq 2
      expect(response_body["rounds"][0]["user"]["userName"]).to eq user1.user_name
    end

    it "returns nil user information if user is not logged in" do
      get :index
      response_body = JSON.parse(response.body)

      expect(response_body["rounds"][0]["user"].length).to eq 2
      expect(response_body["rounds"][0]["user"]["userName"]).to eq nil
    end
  end
end
