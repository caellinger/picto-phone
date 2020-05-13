# require 'rails_helper'
#
# RSpec.describe Api::V1::DrawingsController, type: :controller do
#   describe "POST#new" do
#     let!(:user_1) { User.create(email: "test1@email.com", user_name: "test_user_1", password: "password") }
#     let!(:user_2) { User.create(email: "test2@email.com", user_name: "test_user_2", password: "password") }
#     let!(:round) { Round.create(starter_name: "test_user", turn_user_id: user_1.id) }
#     let!(:participant_1) { Participant.create(user_id: user_1.id, round_id: round.id, round_starter: true) }
#     let!(:participant_2) { Participant.create(user_id: user_2.id, round_id: round.id, round_starter: true) }
#     let!(:new_drawing) { "http://fallinpets.com/wp-content/uploads/2016/09/cat-funny-600x548.jpg" }
#
#     it "fails to create a new Drawing record for an unauthenticated user" do
#       previous_count = Drawing.count
#       new_json = { payload: {
#         drawing: new_drawing,
#         round_id: round.id,
#         user_id: user_1.id,
#         turn: round.turn
#       } }
#       post :create, params: new_json, format: :json
#       new_count = Drawing.count
#
#       expect(new_count).to eq(previous_count)
#     end
#
#     it "creates a new Drawing record and updates current_participant, next_participant, and Round records for an authenticated user" do
#       sign_in user_1
#       previous_count = Drawing.count
#       previous_turn = round.turn
#       previous_turn_user_id = round.turn_user_id
#       new_json = { payload: {
#         drawing: new_drawing,
#         round_id: round.id,
#         user_id: user_1.id,
#         turn: round.turn
#       } }
#       post :create, params: new_json, format: :json
#       new_count = Drawing.count
#       new_turn = Round.find(round.id).turn
#       new_turn_user_id = Round.find(round.id).turn_user_id
#
#       expect(new_count).to eq(previous_count + 1)
#       expect(Participant.find(participant_1.id).response).not_to eq(nil)
#       expect(new_turn).to eq(previous_turn + 1)
#       expect(new_turn_user_id).to eq(participant_2.user_id)
#       expect(Participant.find(participant_2.id).prompt).not_to eq(nil)
#       expect(Participant.find(participant_2.id).participant_type).to eq("guesser")
#     end
#
#     it "does not create a new Drawing record and returns an error if drawing is nil" do
#       sign_in user_1
#       previous_count = Drawing.count
#       new_json = { payload: {
#         round_id: round.id,
#         user_id: user_1.id,
#         turn: round.turn
#       } }
#       post :create, params: new_json, format: :json
#       response_body = JSON.parse(response.body)
#       new_count = Drawing.count
#
#       expect(new_count).to eq(previous_count)
#       expect(response_body["error"][0]).to eq "Drawing can't be blank"
#     end
#
#     it "does not create a new Drawing record and returns an error if user_id is nil" do
#       sign_in user_1
#       previous_count = Drawing.count
#       new_json = { payload: {
#         drawing: new_drawing,
#         round_id: round.id,
#         turn: round.turn
#       } }
#
#       expect{ post :create, params: new_json, format: :json }.to raise_error(NoMethodError)
#
#       new_count = Drawing.count
#       expect(new_count).to eq(previous_count)
#     end
#
#     it "does not create a new Drawing record and returns an error if round_id is nil" do
#       sign_in user_1
#       previous_count = Drawing.count
#       new_json = { payload: {
#         drawing: new_drawing,
#         user_id: user_1.id,
#         turn: round.turn
#       } }
#
#       expect{ post :create, params: new_json, format: :json }.to raise_error(NoMethodError)
#
#       new_count = Drawing.count
#       expect(new_count).to eq(previous_count)
#     end
#   end
# end
