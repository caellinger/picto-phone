require 'rails_helper'
require_relative '../../app/services/rounds_check.rb'

describe RoundsCheck do
  describe '#in_progress_limit?' do
    context 'when there are 25 or more rounds' do
      it 'returns true' do
        25.times { Round.create(starter_name: "test_user_1", turn_user_id: 1) }
        expect(RoundsCheck.new.in_progress_limit?).to eq true
      end
    end

    context 'when there are fewer than 25 rounds' do
      it 'returns false' do
        24.times { Round.create(starter_name: "test_user_1", turn_user_id: 1) }
        expect(RoundsCheck.new.in_progress_limit?).to eq false
      end
    end
  end

  describe '#joinable_rounds_list' do
    it "only returns rounds that have status = waiting" do
      round_1 = Round.create(starter_name: "test_user_1", turn_user_id: 1)
      round_2 = Round.create(starter_name: "test_user_1", turn_user_id: 1, status: "in progress")

      expect(RoundsCheck.new.joinable_rounds_list).to include round_1
      expect(RoundsCheck.new.joinable_rounds_list).not_to include round_2
    end
  end
end
