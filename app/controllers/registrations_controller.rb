# Devise registrations controller override
class RegistrationsController < Devise::RegistrationsController
	before_action :authenticate_user!
	
  def dashboard
  end
end 