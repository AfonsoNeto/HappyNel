require 'rails_helper'

RSpec.describe User, type: :model do
  it "has valid factory" do
  	@user = create :user
  	expect(@user.valid?).to eq(true)
	end

	# TESTS VALIDATIONS
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

	it "only admin must be devise authenticable" do
		admin 	= create(:user, role: User.roles[:admin])
		member 	= create(:user, role: User.roles[:member])

		expect(admin	.active_for_authentication?).to eq(true)
		expect(member	.active_for_authentication?).to eq(false)
	end
end
