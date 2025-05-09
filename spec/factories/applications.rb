FactoryBot.define do
  factory :application do
    association :job
    candidate_name { Faker::Name.name }
  end
end
