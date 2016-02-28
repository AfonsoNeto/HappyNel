# Devise registrations controller override
class RegistrationsController < Devise::RegistrationsController
  before_action -> { authenticate_user!( force: true ) } 
  before_action :set_poll, only: [:destroy_member]
	
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

  def destroy_member
    @member.destroy
    respond_to do |format|
      format.html { redirect_to authenticated_root_url, notice: 'Membro removido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @member = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:user).permit(:name, :email)
    end
end 