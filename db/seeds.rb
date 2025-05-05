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


# -----------

#   # Add activation event
#   Job::Event::Activated.create!(
#     eventable: job,
#     properties: { reason: 'Initial job posting' }
#   )

#   job
# end

# Create three applications for each job
created_jobs.each do |job|
  3.times do |i|
    application = Application.create!(
      job: job,
      candidate_name: "Candidate #{i+1} for #{job.title}",
    )

    # Since we don't have specific application event types yet,
    # we can create a generic event if needed in the future
    # For example: Application::Event::Submitted.create!(eventable: application)
  end
end

puts "Created #{created_jobs.size} jobs with #{created_jobs.size * 3} applications!"
