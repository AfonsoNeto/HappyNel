require 'rails_helper'

RSpec.describe Poll, type: :model do
  it "has valid factory" do
  	@poll = create :poll
  	expect(@poll.valid?).to eq(true)
	end

	# TESTING VALIDATIONS
	describe "is invalid when" do
		before :each do
			@poll = create :poll
		end

		it "acumulated_score is missing" do
			@poll.acumulated_score = nil
			expect(@poll.valid?).to eq(false)
			expect(@poll.errors[:acumulated_score].any?).to eq(true)
		end

		it "final_result is missing" do
			@poll.final_result = nil
			expect(@poll.valid?).to eq(false)
			expect(@poll.errors[:final_result].any?).to eq(true)
		end
	end
end
