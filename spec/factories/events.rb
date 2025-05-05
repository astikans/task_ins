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

    factory :application_event, class: 'Application::Event' do
      association :eventable, factory: :application
      type { "Application::Event" }

      factory :application_event_note, class: 'Application::Event::Note' do
        type { "Application::Event::Note" }
        properties { { content: "Test note content" } }
      end

      factory :application_event_interview, class: 'Application::Event::Interview' do
        type { "Application::Event::Interview" }
        properties { { interview_date: Date.today.to_s } }
      end

      factory :application_event_hired, class: 'Application::Event::Hired' do
        type { "Application::Event::Hired" }
        properties { { hired_date: Date.today.to_s } }
      end

      factory :application_event_rejected, class: 'Application::Event::Rejected' do
        type { "Application::Event::Rejected" }
      end
    end
  end
end
