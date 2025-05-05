require 'rails_helper'

RSpec.describe Application::Event::Note, type: :model do
  it 'is a subclass of Application::Event' do
    expect(described_class.superclass).to eq(Application::Event)
  end

  describe 'attributes' do
    it 'has a content property' do
      note = described_class.new(properties: { content: 'Test note content' })
      expect(note.content).to eq('Test note content')
    end

    it 'stores content in properties hash' do
      note = described_class.new
      note.content = 'New note content'
      expect(note.properties['content']).to eq('New note content')
    end
  end
end
