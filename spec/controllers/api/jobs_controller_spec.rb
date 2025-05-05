require 'rails_helper'

RSpec.describe Api::JobsController, type: :controller do
  describe 'GET #index' do
    let!(:jobs) { create_list(:job, 3) }

    before { get :index }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns all jobs' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
    end

    it 'assigns all jobs to @jobs' do
      expect(assigns(:jobs)).not_to be_nil
    end
  end
end
