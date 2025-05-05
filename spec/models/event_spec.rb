require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:eventable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type) }
  end

  describe 'callbacks' do
    describe 'after_commit on :create' do
      let(:job) { create(:job) }
      let(:event) { build(:event, eventable: job) }

      it 'calls update_eventable_state' do
        expect(event).to receive(:update_eventable_state)
        event.save!
      end

      it 'calls update_state on the eventable' do
        expect(job).to receive(:update_state).with(event)
        event.save!
      end
    end
  end
end
