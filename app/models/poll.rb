class Poll < ActiveRecord::Base
	has_many :voting_histories, dependent: :destroy
	
	validates :acumulated_score, :final_result, presence: true
	validates :has_finished, inclusion: [true, false]

	def partial_result
		return self.final_result if self.final_result > 0
		return 0 if self.acumulated_score == 0
		return self.acumulated_score / self.voting_histories.has_voted(true).count
	end

	def add_vote(score)
		score = score.try(:to_f)
		return false if score.blank? or score > 5 or score < 1

		total_votes 		= self.voting_histories.count
		computed_votes 	= self.voting_histories.has_voted(true).count

		self.acumulated_score += score
		
		# +1 because this vote is not counted as computed yet
		if computed_votes + 1 == total_votes
			self.final_result = self.acumulated_score / total_votes
			self.has_finished = true

			# Send email to all participant users with the result?
			(User.called_to_vote(self) + User.admins).each do |usr|
				HappyNelMailer.notify_poll_result(usr, self).deliver_now
			end
		end

		self.save
		return true
	end
end
