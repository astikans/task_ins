class Application < ApplicationRecord
  STATES = %w[interview hired rejected applied].freeze

  belongs_to :job
  has_many :events, -> { unscope(where: :type) }, as: :eventable, dependent: :destroy

  validates :candidate_name, presence: true

  store_accessor :projection, :state, :notes_count, :last_interview_date

  scope :ordered, -> { order(id: :asc) }

  after_commit :update_counters, if: :saved_change_to_state?

  def initialize(attributes = nil)
    super
    self.state ||= "applied" # default state
    self.notes_count ||= 0 # default notes count
  end

  def update_counters
    job.update_counter!
  end

  def update_projection!(event)
    case event.type
    when "Application::Event::Interview"
      self.state = "interview"
      self.last_interview_date = event.interview_date
    when "Application::Event::Hired"
      self.state = "hired"
    when "Application::Event::Rejected"
      self.state = "rejected"
    when "Application::Event::Note"
      self.notes_count += 1
    end

    save!
  end
end
