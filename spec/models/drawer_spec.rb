require 'rails_helper'

RSpec.describe Drawer, type: :model do
  it { should have_valid(:participant_id).when(1) }
  it { should_not have_valid(:participant_id).when(nil, "") }

  it { should have_valid(:prompt).when("elephant") }
  it { should have_valid(:prompt).when(nil, "") }

  it { should have_valid(:drawing_location).when("www.test.com") }
  it { should have_valid(:drawing_location).when(nil, "") }

  it { should belong_to(:participant) }
end
