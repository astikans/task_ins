require 'rails_helper'

RSpec.describe Application::Event::Interview, type: :model do
  it 'is a subclass of Application::Event' do
    expect(described_class.superclass).to eq(Application::Event)
  end

  describe 'attributes' do
    it 'has an interview_date property' do
      interview_date = Date.today.to_s
      interview = described_class.new(properties: { interview_date: interview_date })
      expect(interview.interview_date).to eq(interview_date)
    end

    it 'stores interview_date in properties hash' do
      interview = described_class.new
      interview_date = Date.today.to_s
      interview.interview_date = interview_date
      expect(interview.properties['interview_date']).to eq(interview_date)
    end
  end
end
