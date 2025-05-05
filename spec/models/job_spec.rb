require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'attributes' do
    it { should respond_to(:state) }

    it 'uses store_accessor for state' do
      job = create(:job, state: 'active')
      expect(job.state).to eq('active')
    end
  end
end
