class Job < ApplicationRecord
  has_many :events, -> { unscope(where: :type) }, as: :eventable, dependent: :destroy
  has_many :applications, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  scope :active, -> { where("jobs.projection ->> 'state' = ?", "activated") }

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
