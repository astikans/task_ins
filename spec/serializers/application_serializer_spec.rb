require 'rails_helper'

RSpec.describe ApplicationSerializer do
  let(:application) { build_stubbed(:application, projection: { state: nil, notes_count: nil }) }
  let(:serializer) { described_class.new(application) }
  let(:serialization) { JSON.parse(serializer.to_json) }

  it 'includes the expected attributes' do
    expect(serialization.keys).to match_array([ 'id', 'job_name', 'candidate_name', 'state', 'notes_count', 'last_interview_date' ])
  end

  describe '#state' do
    it 'returns applied when state is nil' do
      expect(serialization['state']).to eq('applied')
    end

    it 'returns the state value when present' do
      application.projection = { state: 'interview' }
      new_serialization = JSON.parse(described_class.new(application).to_json)
      expect(new_serialization['state']).to eq('interview')
    end
  end

  describe '#notes_count' do
    it 'returns 0 when notes_count is nil' do
      expect(serialization['notes_count']).to eq(0)
    end

    it 'returns the notes_count value when present' do
      application.projection = { notes_count: 5 }
      new_serialization = JSON.parse(described_class.new(application).to_json)
      expect(new_serialization['notes_count']).to eq(5)
    end
  end
end
