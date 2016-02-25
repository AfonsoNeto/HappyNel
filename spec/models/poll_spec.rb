require 'rails_helper'

RSpec.describe Poll, type: :model do
  it "has valid factory" do
  	@poll = create :poll
  	expect(@poll.valid?).to be
	end

	# TESTING VALIDATIONS
	describe "is invalid when" do
		before :each do
			@poll = create :poll
		end

		it "acumulated_score is missing" do
			@poll.acumulated_score = nil
			expect(@poll.valid?).to eq(false)
			expect(@poll.errors[:acumulated_score].any?).to be
		end

		it "final_result is missing" do
			@poll.final_result = nil
			expect(@poll.valid?).to eq(false)
			expect(@poll.errors[:final_result].any?).to be
		end

		it "has_finished is missing" do
			@poll.has_finished = nil
			expect(@poll.valid?).to eq(false)
			expect(@poll.errors[:has_finished].any?).to be
		end
	end

	# TESTING METHODS AND CALLBACKS
	describe "it should" do
		before :each do
			@poll = create :poll, acumulated_score: 0, final_result: 0
			@voting_histories = create_list :voting_history, rand(2..10), poll: @poll
		end

		it "add new vote" do
			expect(@poll.acumulated_score).to eq(0)
			score = 10.0
			@poll.add_vote(score)
			expect(@poll.acumulated_score).to eq(score)
			@poll.add_vote(score)
			expect(@poll.acumulated_score).to eq(score * 2)
		end

		it "calculate partial result" do
			expect(@poll.partial_result).to eq(0)
			score = 10.0
			@poll.add_vote(score)
			expect(@poll.partial_result).to eq(score / @poll.voting_histories.has_voted(true).count)
		end
	end
end
