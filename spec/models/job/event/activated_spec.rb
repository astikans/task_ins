require 'rails_helper'

RSpec.describe Job::Event::Activated, type: :model do
  it 'is a subclass of Job::Event' do
    expect(described_class.superclass).to eq(Job::Event)
  end

  describe 'behavior' do
    let(:job) { create(:job, state: 'deactivated') }
    let(:event) { create(:job_event_activated, eventable: job) }

    it 'sets the job state to activated' do
      expect { event }.to change { job.reload.state }.from('deactivated').to('activated')
    end
  end
end
