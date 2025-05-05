require 'rails_helper'

RSpec.describe Application::Event::Hired, type: :model do
  it 'is a subclass of Application::Event' do
    expect(described_class.superclass).to eq(Application::Event)
  end

  describe 'attributes' do
    it 'has a hired_date property' do
      hired_date = Date.today.to_s
      hired = described_class.new(properties: { hired_date: hired_date })
      expect(hired.hired_date).to eq(hired_date)
    end

    it 'stores hired_date in properties hash' do
      hired = described_class.new
      hired_date = Date.today.to_s
      hired.hired_date = hired_date
      expect(hired.properties['hired_date']).to eq(hired_date)
    end
  end

  describe 'behavior' do
    let(:application) { create(:application, state: "applied") }
    let(:hired_event) { build(:application_event_hired, eventable: application) }

    it 'changes the application state to hired when created' do
      expect { hired_event.save! }.to change { application.reload.state }.to('hired')
    end
  end
end
