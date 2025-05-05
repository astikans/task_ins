FactoryBot.define do
  factory :event do
    association :eventable, factory: :job
    type { "Job::Event" }

    factory :job_event, class: 'Job::Event' do
      type { "Job::Event" }

      factory :job_event_activated, class: 'Job::Event::Activated' do
        type { "Job::Event::Activated" }
      end

      factory :job_event_deactivated, class: 'Job::Event::Deactivated' do
        type { "Job::Event::Deactivated" }
      end
    end
  end
end
