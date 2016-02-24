FactoryGirl.define do
  factory :poll, :class => 'Poll' do
    acumulated_score Faker::Number.decimal(1, 1)
    final_result 		 Faker::Number.decimal(1, 1)
  end
end