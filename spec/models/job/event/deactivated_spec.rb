require 'rails_helper'

RSpec.describe Job::Event::Deactivated, type: :model do
  it 'is a subclass of Job::Event' do
    expect(described_class.superclass).to eq(Job::Event)
  end

  describe 'behavior' do
    let(:job) { create(:job, state: 'activated') }
    let(:event) { create(:job_event_deactivated, eventable: job) }

    it 'sets the job state to deactivated' do
      expect { event }.to change { job.reload.state }.from('activated').to('deactivated')
    end
  end
end
