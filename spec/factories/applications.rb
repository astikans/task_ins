FactoryBot.define do
  factory :application do
    association :job
    candidate_name { Faker::Name.name }
    state { [ "applied", "interview", "hired", "rejected" ].sample }

    # Initialize the projection hash for store_accessor fields
    projection { { notes_count: rand(0..10) } }
  end
end
