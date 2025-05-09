class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :state, :hired_applications_count, :rejected_applications_count, :ongoing_applications_count

  def ongoing_applications_count
    object.applied_applications_count + object.interview_applications_count
  end
end
