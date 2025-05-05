require 'rails_helper'

RSpec.describe Job::Event, type: :model do
  it 'is a subclass of Event' do
    expect(described_class.superclass).to eq(Event)
  end
end
