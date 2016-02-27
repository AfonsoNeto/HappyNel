class PollsController < ApplicationController
  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.create(has_finished: false)

    respond_to do |format|
      if User.send_call_for_members(@poll)
        format.html { redirect_to authenticated_root_url, notice: 'Enquete enviada com sucesso.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { redirect_to authenticated_root_url, alert: 'Algo deu errado. Tente novamente!' }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET
  def vote
    @token = params[:token]
    flash[:token] = params[:token]
    @voting_history = VotingHistory.where(token: @token).take

    if @voting_history.blank?
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    elsif @voting_history.has_voted
      redirect_to :thanks_to_vote
    end
  end

  # PATCH/PUT
  def set_score
    token = flash[:token] or params[:token]
    @voting_history = VotingHistory.find_by(token: token)
    @voting_history.poll.add_vote(params[:score]) unless @voting_history.has_voted

    @voting_history.update_attributes({has_voted: true})

    respond_to do |format|
      format.html { redirect_to :thanks_to_vote }
    end
  end
end
