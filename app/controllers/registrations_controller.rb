# Devise registrations controller override
class RegistrationsController < Devise::RegistrationsController
	before_action :authenticate_user!
	
  def dashboard
  	@members 	= User.members
  	@polls 		= Poll.all
  end
end 