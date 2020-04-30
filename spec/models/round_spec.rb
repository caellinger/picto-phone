require 'rails_helper'

RSpec.describe Round, type: :model do
  it { should have_valid(:prompt).when("elephant") }
  it { should_not have_valid(:prompt).when( nil, "") }
end
