class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true

  validates :type, presence: true

  scope :exclude_job_events, -> { where.not("type LIKE ?", "Job::Event%") }

  after_commit :update_eventable_state, on: :create

  private

  def update_eventable_state
    eventable.update_state(self)
  end
end
