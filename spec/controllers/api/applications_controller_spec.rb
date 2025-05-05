require 'rails_helper'

RSpec.describe Api::ApplicationsController, type: :controller do
  describe 'GET #index' do
    let!(:active_job) { create(:job, state: 'activated') }
    let!(:inactive_job) { create(:job, state: 'deactivated') }
    let!(:applications_for_active_job) { create_list(:application, 2, job: active_job) }
    let!(:application_for_inactive_job) { create(:application, job: inactive_job) }

    before { get :index }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns only applications for active jobs' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)

      job_ids = json_response.map { |app| app['job_id'] }
      expect(job_ids).not_to include(inactive_job.id)
    end

    it 'includes job name in serialized output' do
      json_response = JSON.parse(response.body)
      expect(json_response.first['job_name']).to eq(active_job.title)
    end

    it 'assigns applications with active jobs to @applications' do
      expect(assigns(:applications)).to match_array(applications_for_active_job)
    end
  end
end
