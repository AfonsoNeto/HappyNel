# Preview all emails at http://localhost:3000/rails/mailers/happy_nel_mailer
class HappyNelMailerPreview < ActionMailer::Preview
	def call_to_vote
		HappyNelMailer.call_to_vote(User.take.try(:email), VotingHistory.take)
	end

	def notify_poll_result
		HappyNelMailer.notify_poll_result(User.take, Poll.take)
	end
end
