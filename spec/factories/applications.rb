FactoryBot.define do
  factory :application do
    association :job
    candidate_name { Faker::Name.name }
    state { [ "applied", "interview", "hired", "rejected" ].sample }
  end
end
