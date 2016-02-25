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
    @new_member          = User.new(member_params)
    @new_member.role     = User.roles[:member]
    @new_member.password = Faker::Internet.password

  	respond_to do |format|
      if @new_member.save
        flash[:notice] = "Membro criado com sucesso!"
        format.js {render :js => "window.location.href='#{authenticated_root_url}'"}
      else
        format.js
      end
  	end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:user).permit(:name, :email)
  end
end 