require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'associations' do
    it { should belong_to(:job) }
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:candidate_name) }
  end

  describe 'store accessors' do
    it 'has state accessor' do
      application = build(:application, projection: { state: 'submitted' })
      expect(application.state).to eq('submitted')
    end

    it 'has notes_count accessor' do
      application = build(:application, projection: { notes_count: 5 })
      expect(application.notes_count).to eq(5)
    end

    it 'has last_interview_date accessor' do
      date = Date.today
      application = build(:application, projection: { last_interview_date: date })
      expect(application.last_interview_date).to eq(date.to_s)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:application)).to be_valid
    end
  end

  describe '#update_state' do
    let(:application) { create(:application) }

    context 'when receiving an Interview event' do
      it 'updates state to interview and sets last_interview_date' do
        interview_date = Date.today
        event = Application::Event::Interview.new(interview_date: interview_date)

        application.update_state(event)

        expect(application.state).to eq('interview')
        expect(application.last_interview_date).to eq(interview_date.to_s)
      end
    end

    context 'when receiving a Hired event' do
      it 'updates state to hired' do
        event = Application::Event::Hired.new

        application.update_state(event)

        expect(application.state).to eq('hired')
      end
    end

    context 'when receiving a Rejected event' do
      it 'updates state to rejected' do
        event = Application::Event::Rejected.new

        application.update_state(event)

        expect(application.state).to eq('rejected')
      end
    end

    context 'when receiving a Note event' do
      it 'increments notes_count' do
        application.projection = { notes_count: 2 }
        event = Application::Event::Note.new

        application.update_state(event)

        expect(application.notes_count).to eq(3)
      end

      it 'handles nil notes_count' do
        application.projection = { notes_count: nil }
        event = Application::Event::Note.new

        application.update_state(event)

        expect(application.notes_count).to eq(1)
      end
    end
  end
end
