class Api::ApplicationsController < ApplicationController
  def index
    @applications = Application.joins(:job).merge(Job.active).includes(:job)
    render json: @applications # uses by default the ApplicationSerializer
  end
end
