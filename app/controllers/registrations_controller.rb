# Devise registrations controller override
class RegistrationsController < Devise::RegistrationsController
	before_action :authenticate_user!
	
  def dashboard
  	@members 		= User.members
  	@polls 			= Poll.all
  	@new_member = User.new
  end

  # POST
  def create_member
  	respond_to do |format|
  		format.js
  	end
  end
end 