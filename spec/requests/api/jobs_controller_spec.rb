require 'rails_helper'

RSpec.describe Api::JobsController, type: :request do
  describe 'GET /api/jobs' do
    let!(:jobs) { create_list(:job, 3) }

    before { get '/api/jobs' }

    it 'returns all jobs' do
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
      expect(json_response.first.keys).to include('id', 'title', 'description', 'state')
    end

    it 'uses the JobSerializer' do
      expect(JobSerializer).to receive(:new).at_least(1).times.and_call_original
      get '/api/jobs'
    end
  end
end
