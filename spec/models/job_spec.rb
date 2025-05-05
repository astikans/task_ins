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

  describe 'attributes' do
    it { should respond_to(:state) }

    it 'uses store_accessor for state' do
      job = create(:job, state: 'active')
      expect(job.state).to eq('active')
    end
  end

  describe 'scopes' do
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
end
