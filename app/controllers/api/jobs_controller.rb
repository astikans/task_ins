class Api::JobsController < ApplicationController
  def index
    @jobs = Job.all
    render json: @jobs # uses by default the JobSerializer
  end
end
