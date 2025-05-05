class Application < ApplicationRecord
  belongs_to :job
  has_many :events, -> { unscope(where: :type) }, as: :eventable, dependent: :destroy

  validates :candidate_name, presence: true

  store_accessor :projection, :state, :notes_count, :last_interview_date

  def update_state(event)
    case event.type
    when "Application::Event::Interview"
      self.state = "interview"
      self.last_interview_date = event.interview_date
    when "Application::Event::Hired"
      self.state = "hired"
    when "Application::Event::Rejected"
      self.state = "rejected"
    when "Application::Event::Note"
      self.notes_count = (notes_count || 0) + 1
    end

    save!
  end
end
