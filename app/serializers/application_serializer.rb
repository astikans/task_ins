class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :job_name, :candidate_name, :state, :notes_count, :last_interview_date

  def job_name
    object.job.title
  end

  def state
    object.state || "applied"
  end

  def notes_count
    object.notes_count || 0
  end
end
