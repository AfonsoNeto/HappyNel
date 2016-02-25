class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.create(has_finished: false)

    respond_to do |format|
      if User.send_call_for_members(@poll)
        format.html { redirect_to authenticated_root_url, notice: 'Enquete enviada com sucesso.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { redirect_to authenticated_root_url, notice: 'Algo deu errado. Tente novamente!' }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET
  def vote
    @token = params[:token]
    @voting_history = VotingHistory.where(token: @token).take

    if @voting_history.blank?
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    elsif @voting_history.has_voted
      redirect_to :thanks_to_vote
    end
  end

  # PATCH/PUT
  def set_score
    @voting_history = VotingHistory.find_by(token: params[:token])
    @voting_history.poll.add_vote(params[:score]) unless @voting_history.has_voted

    @voting_history.update_attributes({has_voted: true})

    respond_to do |format|
      format.html { redirect_to :thanks_to_vote }
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:acumulated_score, :final_result)
    end
end
