require 'rails_helper'

RSpec.describe Round, type: :model do
  it { should have_valid(:starter_name).when("User1")}
  it { should_not have_valid(:starter_name).when(nil, "")}

  it { should have_valid(:round_prompt).when("elephant") }
  it { should have_valid(:current_prompt).when("elephant") }

  it { should have_valid(:status).when("in progress") }

  it { should have_valid(:turn).when(0) }
  it { should have_valid(:turn_user_id).when(1) }
end
