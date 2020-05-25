require 'rails_helper'

describe RoundJson do
  describe '#return_round_info' do
    it "returns information about the round" do
      user = User.create(user_name: "test_user_1", email: "test1@email.com", password: "password")
      round = Round.create(starter_name: "test_user_1", turn_user_id: user.id)

      returned_data = RoundJson.new.return_round_info(round)

      expect(returned_data[:id]).to eq(round.id)
      expect(returned_data[:starterName]).to eq(user.user_name)
      expect(returned_data[:status]).to eq("waiting")
      expect(returned_data[:turn]).to eq(0)
      expect(returned_data[:turnUserID]).to eq(user.id)
      expect(returned_data[:roundPrompt]).to eq(nil)
      expect(returned_data[:currentPrompt]).to eq(nil)
    end
  end
end
