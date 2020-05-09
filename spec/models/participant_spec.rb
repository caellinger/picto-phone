require 'rails_helper'

RSpec.describe Participant, type: :model do
  it { should have_valid(:round_id).when(1) }
  it { should_not have_valid(:round_id).when(nil, "") }

  it { should have_valid(:user_id).when(1) }
  it { should_not have_valid(:user_id).when(nil, "") }

  it { should have_valid(:participant_type).when("drawer") }
  it { should have_valid(:participant_type).when("guesser") }
  it { should have_valid(:participant_type).when(nil, "") }

  it { should have_valid(:round_starter).when(true) }
  it { should have_valid(:round_starter).when(false) }
  it { should_not have_valid(:round_starter).when(nil, "") }

  it { should belong_to(:user) }
  it { should belong_to(:round) }
end
