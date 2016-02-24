require 'rails_helper'

RSpec.describe Poll, type: :model do
  before :each do
  	@poll = create :poll
  end

  it "has valid factory" do
  	expect(@poll.valid?).to eq(true)
	end
end
