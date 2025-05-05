class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :state

  def state
    object.state || "deactivated"
  end
end
