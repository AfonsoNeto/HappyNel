FactoryGirl.define do
  factory :poll, :class => 'Poll' do
    acumulated_score { Faker::Number.decimal(1, 1) }
    final_result 		 { Faker::Number.decimal(1, 1) }
    has_finished		 { [true, false].sample 			 }
  end
end