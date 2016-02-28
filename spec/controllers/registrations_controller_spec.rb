require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
	describe "with logged in user" do
		before :each do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@admin   = create :user, role: User.roles[:admin]
			@members = create_list :user, rand(2..10), role: User.roles[:member]
		end

		context "get dashboard" do
			it "and succeed" do
				sign_in @admin
				get :dashboard
				expect(response).to have_http_status(:ok)
				expect(response).to render_template(:dashboard)
			end
		end

		context "post create_member" do
			it "with valid params and succeed" do
				sign_in @admin
				expect {
					post :create_member, {user: attributes_for(:user), format: :js}
				}.to change(User.members, :count).by(1)
				expect(flash[:notice].blank?).to eq(false)
				expect(response).to have_http_status(:ok)
			end
		end

		context "post create_member" do
			it "with invalid params and fail" do
				sign_in @admin
				expect {
					post :create_member, {user: {name: nil, email: nil}, format: :js}
				}.to change(User.members, :count).by(0)
			end
		end

		context "delete destroy_member" do
			it "and succeed" do
				sign_in @admin
				expect {
					post :destroy_member, {id: @members.sample.id}
				}.to change(User.members, :count).by(-1)
			end
		end

	end

	describe "with logged out user" do
		before :each do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@admin   = create :user, role: User.roles[:admin]
			@members = create_list :user, rand(2..10), role: User.roles[:member]
		end

		context "get dashboard" do
			it "and fail" do
				sign_in @members.sample
				get :dashboard
				expect(response).to have_http_status(:redirect)
				expect(response).to redirect_to(:new_user_session)
			end
		end

		context "post create_member" do
			it "with valid params and fail" do
				expect {
					post :create_member, {user: attributes_for(:user), format: :js}
				}.to change(User.members, :count).by(0)
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context "post create_member" do
			it "with invalid params and fail" do
				expect {
					post :create_member, {user: {name: nil, email: nil}, format: :js}
				}.to change(User.members, :count).by(0)
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context "delete destroy_member" do
			it "and fail" do
				expect {
					post :destroy_member, {id: @members.sample.id}
				}.to change(User.members, :count).by(0)
				expect(response).to have_http_status(:redirect)
				expect(response).to redirect_to(:new_user_session)
			end
		end

	end

end
