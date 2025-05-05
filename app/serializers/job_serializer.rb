class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :state, :hired_applications_count, :rejected_applications_count, :ongoing_applications_count

  def state
    object.state || "deactivated"
  end

  def hired_applications_count
    object.hired_applications_count || 0
  end

  def rejected_applications_count
    object.rejected_applications_count || 0
  end

  def ongoing_applications_count
    (object.applied_applications_count || 0) + (object.interview_applications_count || 0)
  end
end
