require 'rails_helper'

RSpec.describe VotingHistory, type: :model do
  it "has valid factory" do
  	@voting_history = create :voting_history
  	expect(@voting_history.valid?).to eq(true)
	end

	# TESTING VALIDATIONS
	describe "is invalid when" do
		before :each do
			@user 					= create :user
			@voting_history = create :voting_history, user: @user
		end

		describe "user is not set" do
			it "with user= method" do
				@voting_history.user = nil
				expect(@voting_history.valid?).to eq(false)
				@voting_history.user = @user
				expect(@voting_history.valid?).to eq(true)
			end

			it "with member= method" do
				@voting_history.member = nil
				expect(@voting_history.valid?).to eq(false)
				@voting_history.member = @user
				expect(@voting_history.valid?).to eq(true)
			end

			it "with user_id= method" do
				@voting_history.user_id = nil
				expect(@voting_history.valid?).to eq(false)
				@voting_history.user_id = @user.id
				expect(@voting_history.valid?).to eq(true)
			end

			it "with member_id= method" do
				@voting_history.member_id = nil
				expect(@voting_history.valid?).to eq(false)
				@voting_history.member_id = @user.id
				expect(@voting_history.valid?).to eq(true)
			end

			it "with encrypted_member_id= method" do
				@voting_history.encrypted_member_id = nil
				expect(@voting_history.valid?).to eq(false)
				@voting_history.encrypted_member_id = @user.id
				expect(@voting_history.valid?).to eq(true)
			end
		end

		it "poll is missing" do
			@voting_history.poll = nil
			expect(@voting_history.valid?).to eq(false)
			expect(@voting_history.errors[:poll_id].any?).to eq(true)
		end
	end

	# TESTING SCOPES
	describe "must return voting_histories" do
		before :each do
			@voted_histories 		= create_list :voting_history, rand(2..20), has_voted: true
			@unvoted_histories 	= create_list :voting_history, rand(2..20), has_voted: false
		end

		it "that has already been voted" do
			scope_has_voted_true 	= VotingHistory.has_voted(true)
			scope_has_voted_false = VotingHistory.has_voted(false)

			# It will check if each element is included on the scope return
			#   the uniq method must return [true]
			is_every_voted_included = @voted_histories.map {|vh|
				scope_has_voted_true.include? vh
			}.uniq

			# It will check if each element is included on the scope return
			#   the uniq method must return [true]
			is_every_unvoted_included = @unvoted_histories.map {|vh|
				scope_has_voted_false.include? vh
			}.uniq

			# It will check if each element is included on the scope return
			#   the uniq method must return [false] here
			is_every_voted_not_included = @voted_histories.map {|vh|
				scope_has_voted_false.include? vh
			}.uniq

			# It will check if each element is included on the scope return
			#   the uniq method must return [false] here
			is_every_unvoted_not_included = @unvoted_histories.map {|vh|
				scope_has_voted_true.include? vh
			}.uniq

			expect(is_every_voted_included)				.to eq([true])
			expect(is_every_unvoted_included)			.to eq([true])
			expect(is_every_voted_not_included)		.to eq([false])
			expect(is_every_unvoted_not_included)	.to eq([false])
		end
	end

	# TESTING OTHER METHODS AND CALLBACKS
	describe "should" do
		before :each do
			@user 					= create :user
			@voting_history = create :voting_history, user: @user
		end

		it "decrypt member_id" do
			expect(@voting_history.decrypted_member_id).to eq(@user.id)
		end

		it "set token before validation" do
			@voting_history.token = nil
			expect(@voting_history.token.blank?).to eq(true)
			expect(@voting_history.valid?).to eq(true)
			expect(@voting_history.token.blank?).to eq(false)
		end
	end
end
