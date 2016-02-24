class Poll < ActiveRecord::Base
	validates :acumulated_score, :final_result, presence: true
end
