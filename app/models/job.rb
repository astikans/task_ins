class Job < ApplicationRecord
  has_many :events, -> { unscope(where: :type) }, as: :eventable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  store_accessor :projection, :state

  def update_state(event)
    case event.type
    when "Job::Event::Activated"
      self.state = "activated"
    when "Job::Event::Deactivated"
      self.state = "deactivated"
    end

    save!
  end
end
