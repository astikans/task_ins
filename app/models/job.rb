class Job < ApplicationRecord
  has_many :events, -> { unscope(where: :type) }, as: :eventable, dependent: :destroy
  has_many :applications, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  default_scope { order(id: :asc) }
  scope :active, -> { where("jobs.projection ->> 'state' = ?", "activated") }

  store_accessor :projection, :state
  store_accessor :counters, *Application::STATES.map { |state| "#{state}_applications_count" }

  def initialize(attributes = nil)
    super
    self.state ||= "deactivated" # default state
    Application::STATES.each do |state|
      self.send("#{state}_applications_count=", 0) # default counters
    end
  end

  def update_counter!
    Application::STATES.each do |state|
      counts = applications.group("projection ->> 'state'").count
      self.send("#{state}_applications_count=", counts[state] || 0)
    end

    save!
  end

  def update_projection!(event)
    case event.type
    when "Job::Event::Activated"
      self.state = "activated"
    when "Job::Event::Deactivated"
      self.state = "deactivated"
    end

    save!
  end
end
