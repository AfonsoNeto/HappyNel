class Poll < ActiveRecord::Base
	has_many :voting_histories
	
	validates :acumulated_score, :final_result, presence: true
	validates :has_finished, inclusion: [true, false]

	def partial_result
		value_to_take = self.final_result > 0 ? self.final_result : self.acumulated_score
		return value_to_take if value_to_take == 0
		return value_to_take / self.voting_histories.has_voted(true).count
	end

	def add_vote(score)
		return if score.blank?
		score = score.to_f

		total_votes 		= self.voting_histories.count
		computed_votes 	= self.voting_histories.has_voted(true).count

		self.acumulated_score += score
		
		# +1 because this vote is not counted as computed yet
		if computed_votes + 1 == total_votes
			self.final_result = self.acumulated_score / total_votes
			self.has_finished = true
			# Maybe send email to all participant users with the result?
		end

		self.save
	end
end
