class PollsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.create(has_finished: false) if User.members.any?

    respond_to do |format|
      if @poll
        if User.send_call_for_members(@poll)
          format.html { redirect_to authenticated_root_url, notice: 'Enquete enviada com sucesso.' }
          format.json { render :show, status: :created, location: @poll }
        else
          format.html { redirect_to authenticated_root_url, alert: 'Algo deu errado. Tente novamente!' }
          format.json { render json: @poll.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to authenticated_root_url, alert: 'É preciso ter membros cadastrados antes de criar uma enquete.' }
        format.json { render json: @poll.try(:errors), status: :unprocessable_entity }
      end
    end
  end

  # GET
  def vote
    @token = params[:token]
    flash[:token] = params[:token]
    @voting_history = VotingHistory.where(token: @token).take

    if @voting_history.blank?
      flash[:token] = nil
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    elsif @voting_history.has_voted
      flash[:token] = nil
      redirect_to :thanks_to_vote
    end
  end

  # PATCH/PUT
  def set_score
    token = flash[:token].blank? ? params[:token] : flash[:token]
    @voting_history = VotingHistory.where(token: token).take
    
    respond_to do |format|
      if @voting_history.blank?
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }

      elsif !@voting_history.has_voted and @voting_history.poll.add_vote(params[:score])
        @voting_history.has_voted = true
        @voting_history.opinion   = params[:voting_opinion] unless params[:voting_opinion].blank?
        @voting_history.save
        
        format.html { redirect_to :thanks_to_vote }
      else
        format.html { redirect_to vote_poll_url(@voting_history.poll, token: token), alert: "Algo deu errado. Tente novamente!" }
      end
    end

  end
end
