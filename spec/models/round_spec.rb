require 'rails_helper'

RSpec.describe Round, type: :model do
  it { should have_valid(:starter_name).when("User1")}
  it { should_not have_valid(:starter_name).when(nil, "")}

  it { should have_valid(:prompt).when("elephant") }
end
