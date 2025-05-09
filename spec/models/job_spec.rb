require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:applications).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'initialization' do
    it 'sets default state to deactivated' do
      job = Job.new
      expect(job.state).to eq('deactivated')
    end

    it 'initializes all application state counters to zero' do
      job = Job.new
      Application::STATES.each do |state|
        expect(job.send("#{state}_applications_count")).to eq(0)
      end
    end

    it 'allows overriding default state' do
      job = Job.new(state: 'activated')
      expect(job.state).to eq('activated')
    end
  end

  describe 'attributes' do
    it { should respond_to(:state) }

    Application::STATES.each do |state|
      it { should respond_to("#{state}_applications_count") }
    end

    it 'uses store_accessor for state' do
      job = create(:job, state: 'activated')
      expect(job.state).to eq('activated')
    end
  end

  describe 'scopes' do
    describe '.default_scope' do
      it 'orders by id in ascending order' do
        job1 = create(:job)
        job2 = create(:job)
        job3 = create(:job)

        expect(Job.all.to_a).to eq([ job1, job2, job3 ])
      end
    end

    describe '.active' do
      let!(:activated_job) { create(:job, state: 'activated') }
      let!(:deactivated_job) { create(:job, state: 'deactivated') }

      it 'returns only jobs with activated state' do
        expect(Job.active).to include(activated_job)
        expect(Job.active).not_to include(deactivated_job)
      end

      it 'returns the correct count of active jobs' do
        # Create one more active job
        create(:job, state: 'activated')
        expect(Job.active.count).to eq(2)
      end
    end
  end

  describe '#update_counter!' do
    let(:job) { create(:job) }

    context 'with applications in different states' do
      before do
        create(:application, job: job, state: 'applied')
        create(:application, job: job, state: 'interview')
        create(:application, job: job, state: 'hired')
        create(:application, job: job, state: 'rejected')
      end

      it 'updates the counters correctly' do
        job.update_counter!

        expect(job.applied_applications_count).to eq(1)
        expect(job.interview_applications_count).to eq(1)
        expect(job.hired_applications_count).to eq(1)
        expect(job.rejected_applications_count).to eq(1)
      end

      it 'persists the changes to the database' do
        job.update_counter!
        job.reload

        expect(job.applied_applications_count).to eq(1)
        expect(job.interview_applications_count).to eq(1)
        expect(job.hired_applications_count).to eq(1)
        expect(job.rejected_applications_count).to eq(1)
      end
    end

    context 'with no applications' do
      it 'sets all counters to zero' do
        job.update_counter!

        Application::STATES.each do |state|
          expect(job.send("#{state}_applications_count")).to eq(0)
        end
      end

      it 'persists zero counters to the database' do
        job.update_counter!
        job.reload

        Application::STATES.each do |state|
          expect(job.send("#{state}_applications_count")).to eq(0)
        end
      end
    end
  end

  describe '#update_projection!' do
    let(:job) { create(:job) }

    context 'when receiving an Activated event' do
      let(:event) { double('Event', type: 'Job::Event::Activated') }

      it 'updates the state to activated' do
        job.update_projection!(event)
        expect(job.state).to eq('activated')
      end

      it 'persists the state change' do
        job.update_projection!(event)
        job.reload
        expect(job.state).to eq('activated')
      end
    end

    context 'when receiving a Deactivated event' do
      let(:event) { double('Event', type: 'Job::Event::Deactivated') }

      it 'updates the state to deactivated' do
        job.update_projection!(event)
        expect(job.state).to eq('deactivated')
      end

      it 'persists the state change' do
        job.update_projection!(event)
        job.reload
        expect(job.state).to eq('deactivated')
      end
    end
  end
end
