require 'rails_helper'

RSpec.describe JobSerializer do
  let(:job) { build_stubbed(:job) }
  let(:serializer) { described_class.new(job) }
  let(:serialization) { JSON.parse(serializer.to_json) }

  it 'includes the expected attributes' do
    expect(serialization.keys).to match_array([ 'id', 'title', 'description', 'state', 'hired_applications_count', 'rejected_applications_count', 'ongoing_applications_count' ])
  end

  describe '#state' do
    it 'returns the state value' do
      job.state = 'active'
      new_serialization = JSON.parse(described_class.new(job).to_json)
      expect(new_serialization['state']).to eq('active')
    end
  end

  describe '#hired_applications_count' do
    it 'returns the hired_applications_count value' do
      job.hired_applications_count = 5
      new_serialization = JSON.parse(described_class.new(job).to_json)
      expect(new_serialization['hired_applications_count']).to eq(5)
    end
  end

  describe '#rejected_applications_count' do
    it 'returns the rejected_applications_count value' do
      job.rejected_applications_count = 3
      new_serialization = JSON.parse(described_class.new(job).to_json)
      expect(new_serialization['rejected_applications_count']).to eq(3)
    end
  end

  describe '#ongoing_applications_count' do
    it 'returns the sum of applied_applications_count and interview_applications_count' do
      job.applied_applications_count = 2
      job.interview_applications_count = 3
      new_serialization = JSON.parse(described_class.new(job).to_json)
      expect(new_serialization['ongoing_applications_count']).to eq(5)
    end
  end
end
