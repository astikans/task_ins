class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true

  validates :type, presence: true

  default_scope { order(created_at: :asc) }

  after_commit :update_eventable_state, on: :create

  private

  def update_eventable_state
    eventable.update_state(self)
  end
end
