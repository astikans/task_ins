require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'constants' do
    it 'defines STATES with expected values' do
      expect(Application::STATES).to eq(%w[interview hired rejected applied])
    end
  end

  describe 'associations' do
    it { should belong_to(:job) }
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:candidate_name) }
  end

  describe 'scopes' do
    describe 'default_scope' do
      it 'orders by id ascending' do
        job = create(:job)
        app3 = create(:application, job: job)
        app1 = create(:application, job: job)
        app2 = create(:application, job: job)

        expect(Application.all).to eq([ app3, app1, app2 ])
      end
    end
  end

  describe 'callbacks' do
    it 'calls update_counters after commit' do
      application = build(:application)
      job = application.job

      expect(job).to receive(:update_counter!)
      application.save!
    end
  end

  describe 'store accessors' do
    it 'has state accessor' do
      application = build(:application, projection: { state: 'interview' })
      expect(application.state).to eq('interview')
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

  describe '#update_counters' do
    it 'calls update_counter! on the associated job' do
      application = create(:application)
      job = application.job

      expect(job).to receive(:update_counter!)
      application.update_counters
    end
  end

  describe '#update_projection!' do
    let(:application) { create(:application) }

    context 'when receiving an Interview event' do
      it 'updates state to interview and sets last_interview_date' do
        interview_date = Date.today
        event = double('Event', type: 'Application::Event::Interview', interview_date: interview_date)

        application.update_projection!(event)

        expect(application.state).to eq('interview')
        expect(application.last_interview_date).to eq(interview_date.to_s)
      end
    end

    context 'when receiving a Hired event' do
      it 'updates state to hired' do
        event = double('Event', type: 'Application::Event::Hired')

        application.update_projection!(event)

        expect(application.state).to eq('hired')
      end
    end

    context 'when receiving a Rejected event' do
      it 'updates state to rejected' do
        event = double('Event', type: 'Application::Event::Rejected')

        application.update_projection!(event)

        expect(application.state).to eq('rejected')
      end
    end

    context 'when receiving a Note event' do
      it 'increments notes_count' do
        application.projection = { notes_count: 2 }
        event = double('Event', type: 'Application::Event::Note')

        application.update_projection!(event)

        expect(application.notes_count).to eq(3)
      end

      it 'handles nil notes_count' do
        application.projection = { notes_count: nil }
        event = double('Event', type: 'Application::Event::Note')

        application.update_projection!(event)

        expect(application.notes_count).to eq(1)
      end
    end
  end
end
