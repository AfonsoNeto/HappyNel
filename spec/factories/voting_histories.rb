FactoryGirl.define do
  factory :voting_history do
		association :poll
		has_voted		{ [true, false].sample 				}
		token				{ SecureRandom.urlsafe_base64 }
		user				{ create :user }
  end
end
