require 'rails_helper'

RSpec.describe User, type: :model do
  it "has valid factory" do
  	@user = create :user
  	expect(@user.valid?).to eq(true)
	end

	# TESTING VALIDATIONS
	describe "is invalid when" do
		before :each do
			@user = create :user
		end

		it "name is missing" do
			@user.name = nil
			expect(@user.valid?).to eq(false)
			expect(@user.errors[:name].any?).to eq(true)
		end

		it "email is missing" do
			@user.email = nil
			expect(@user.valid?).to eq(false)
			expect(@user.errors[:email].any?).to eq(true)
		end

		it "password is missing" do
			@user.password = nil
			expect(@user.valid?).to eq(false)
			expect(@user.errors[:password].any?).to eq(true)
		end

		it "role is missing" do
			@user.role = nil
			expect(@user.valid?).to eq(false)
			expect(@user.errors[:role].any?).to eq(true)
		end

		it "password and password_confirmation doesn't match" do
			@user.password_confirmation = Faker::Internet.password
			expect(@user.valid?).to eq(false)
			expect(@user.errors[:password_confirmation].any?).to eq(true)
		end
	end

	# TESTING SCOPES
	describe "must return users" do
		def create_voting_histories(users, poll)
			all_voting_histories = []
			users_that_has_voted = []
			users.each do |usr|
				has_voted = [true, false].sample
				all_voting_histories << create(:voting_history, poll: poll, user: usr, has_voted: has_voted)
				users_that_has_voted << usr if has_voted
			end

			return users_that_has_voted
		end

		before :each do
			@poll									= create :poll
			@users 								= create_list :user, rand(2..20)
			@users_that_has_voted	=	create_voting_histories(@users, @poll)
			@voting_histories 		= VotingHistory.all
			@voted_histories			= VotingHistory.has_voted(true)
		end

		it "that has been called to vote on poll" do
			called_ones = User.called_to_vote(@poll)

			# It will check if each element is included on the scope return
			#   the uniq method must return [true] here
			was_every_user_called = @users.map {|usr|
				called_ones.include? usr
			}.uniq

			expect(was_every_user_called).to eq([true])
		end

		it "that has already voted on poll" do
			already_voted_ones = User.has_voted(@poll)

			# It will check if each element is included on the scope return
			#   the uniq method must return [true] here
			has_these_guys_voted = @users_that_has_voted.map {|usr|
				already_voted_ones.include? usr
			}.uniq
			
			expect(has_these_guys_voted).to eq([true])
		end
	end

	it "only admin must be devise authenticable" do
		admin 	= create(:user, role: User.roles[:admin])
		member 	= create(:user, role: User.roles[:member])

		expect(admin	.active_for_authentication?).to eq(true)
		expect(member	.active_for_authentication?).to eq(false)
	end
end
