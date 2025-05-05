FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    state { [ "deactivated", "activated" ].sample }
  end
end
