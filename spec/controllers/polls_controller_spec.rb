require 'rails_helper'

RSpec.describe PollsController, type: :controller do
	describe "POST #create" do
		before :each do
			@admin   = create :user, role: User.roles[:admin]
			@members = create_list :user, rand(2..10), role: User.roles[:member]
		end

		context "with logged in admin" do
			it "should post create and succeed" do
				sign_in @admin
				post :create
				expect(response).to have_http_status(:redirect)
				expect(response).to redirect_to(:authenticated_root)
				expect(flash[:notice].blank?).to eq(false)
				expect(VotingHistory.where(poll: Poll.last).count).to eq(@members.count)
			end
		end

		context "with logged out user" do
			it "should post create and fail" do
				post :create
				expect(response).to have_http_status(:redirect)
				expect(response).to redirect_to(:new_user_session)
				expect(Poll.count).to eq(0)
			end

			context "should get vote" do
				before :each do
					@user = @members.sample
					@poll = create :poll, has_finished: true
					@voting_history = create :voting_history, user: @user, poll: @poll, has_voted: false
					@token = VotingHistory.last.token
				end

				it "with valid token" do
					get :vote, {id: @poll.id, token: @token}
					expect(response).to have_http_status(:ok)
					expect(response).to render_template(:vote)
					expect(flash[:token].blank?).to eq(false)
				end

				it "with valid token and already voted" do
					@voting_history.update_attributes({has_voted: true})
					get :vote, {id: @poll.id, token: @token}
					expect(response).to have_http_status(:redirect)
					expect(response).to redirect_to(:thanks_to_vote)
				end

				it "with invalid token" do
					@voting_history.update_attributes({has_voted: true})
					get :vote, {id: @poll.id, token: Faker::Bitcoin.address}
					expect(response).to have_http_status(:not_found)
				end
			end
		end

		context "should post set_score" do
			before :each do
				@user 					= @members.sample
				@poll 					= create :poll, has_finished: false, acumulated_score: 0, final_result: 0
				@voting_history = create :voting_history, user: @user, poll: @poll, has_voted: false
				@token 					= VotingHistory.last.token
				@valid_score 		= rand(1..5)
				@invalid_score 	= rand(6..20)
			end

			it "with valid token and valid score" do
				post :set_score, {id: @poll.id, token: @token, score: @valid_score}
				expect(Poll.last.acumulated_score).to eq(@valid_score)
				expect(VotingHistory.last.has_voted).to be
				expect(response).to have_http_status(:redirect)
			end

			it "with valid token but invalid score" do
				post :set_score, {id: @poll.id, token: @token, score: @invalid_score}
				expect(Poll.last.acumulated_score).to eq(0)
				expect(VotingHistory.last.has_voted).to eq(false)
				expect(flash[:alert].blank?).to eq(false)
				expect(response).to have_http_status(:redirect)
			end

			it "with invalid token" do
				@voting_history.update_attributes({has_voted: true})
				post :set_score, {id: @poll.id, token: Faker::Bitcoin.address}
				expect(response).to have_http_status(:not_found)
			end
		end

	end
end
