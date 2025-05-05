require 'rails_helper'

RSpec.describe Application::Event::Rejected, type: :model do
  it 'is a subclass of Application::Event' do
    expect(described_class.superclass).to eq(Application::Event)
  end

  describe 'behavior' do
    let(:application) { create(:application, state: 'interviewing') }
    let(:rejected_event) { build(:application_event_rejected, eventable: application) }

    it 'changes the application state to rejected when created' do
      expect { rejected_event.save! }.to change { application.reload.state }.to('rejected')
    end
  end
end
