# 1st job
no_state_job = Job.create!(
  title: 'No State Job',
  description: 'A job with no state, default should be deactivated'
)


# 2nd job
active_job = Job.create!(
  title: 'RoR Developer',
  description: 'Looking for an experienced RoR developer'
)

Job::Event::Activated.create!(
  eventable: active_job,
)


# 3rd job
deactivated_job = Job.create!(
  title: 'DevOps Engineer',
  description: 'Seeking a DevOps engineer with experience in AWS'
)

Job::Event::Activated.create!(
  eventable: deactivated_job,
)
Job::Event::Deactivated.create!(
  eventable: deactivated_job,
)


# 1st application
no_status_application = Application.create!(
  job: active_job,
  candidate_name: 'John Doe'
)


# 2nd application
interview_application = Application.create!(
  job: active_job,
  candidate_name: 'Jane'
)

Application::Event::Interview.create!(
  eventable: interview_application,
  interview_date: Date.today
)

# add note
Application::Event::Note.create!(
  eventable: interview_application,
  content: 'This is a note'
)

# add another note
Application::Event::Note.create!(
  eventable: interview_application,
  content: 'This is another note'
)


# 3rd application
hired_application = Application.create!(
  job: active_job,
  candidate_name: 'Alan'
)

Application::Event::Hired.create!(
  eventable: hired_application,
  hired_date: Date.today
)


# 4th application
rejected_application = Application.create!(
  job: active_job,
  candidate_name: 'Mary'
)

Application::Event::Interview.create!(
  eventable: rejected_application,
  interview_date: Date.today
)

Application::Event::Rejected.create!(
  eventable: rejected_application
)


# 5th application for deactivated job
deactivated_job_application = Application.create!(
  job: deactivated_job,
  candidate_name: 'John Smith'
)


puts "Seeding done"
