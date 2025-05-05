require 'rails_helper'

RSpec.describe JobSerializer do
  let(:job) { build_stubbed(:job, state: nil) }
  let(:serializer) { described_class.new(job) }
  let(:serialization) { JSON.parse(serializer.to_json) }

  it 'includes the expected attributes' do
    expect(serialization.keys).to match_array([ 'id', 'title', 'description', 'state' ])
  end

  describe '#state' do
    it 'returns deactivated when state is nil' do
      expect(serialization['state']).to eq('deactivated')
    end

    it 'returns the state value when present' do
      job.state = 'active'
      new_serialization = JSON.parse(described_class.new(job).to_json)
      expect(new_serialization['state']).to eq('active')
    end
  end
end
