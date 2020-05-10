require 'rails_helper'

RSpec.describe Drawing, type: :model do
  it { should have_valid(:participant_id).when(1) }
  it { should_not have_valid(:participant_id).when(nil, "") }

  it { should belong_to(:participant) }
end
