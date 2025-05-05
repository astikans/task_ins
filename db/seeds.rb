# Create two jobs
jobs = [
  {
    title: 'Full-Stack Developer',
    description: 'Looking for an experienced full-stack developer proficient in Ruby on Rails and React.js'
  },
  {
    title: 'DevOps Engineer',
    description: 'Seeking a DevOps engineer with experience in AWS, Docker, and CI/CD pipelines'
  }
]

created_jobs = jobs.map do |job_attrs|
  job = Job.create!(job_attrs)
end

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
