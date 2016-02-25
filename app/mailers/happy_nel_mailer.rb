class HappyNelMailer < ApplicationMailer

	def call_to_vote(user_email, voting_history)
		@caller_name 	= User.admins.take.try(:name) or "Admin"
    @voting_url 	= poll_vote_url(voting_history.poll, token: voting_history.token)
    mail(to: user_email, subject: '[HappyNel] Nova enquete aguardando seu voto.')
  end
end
