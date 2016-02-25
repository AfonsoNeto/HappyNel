class Poll < ActiveRecord::Base
	has_many :voting_histories
	
	validates :acumulated_score, :final_result, presence: true
	validates :has_finished, inclusion: [true, false]
end
