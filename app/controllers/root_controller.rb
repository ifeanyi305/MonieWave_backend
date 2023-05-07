class RootController < ApplicationController
  skip_before_action :authenticate_request
  def index
    render json: { message: 'Server running!!!' }, status: :ok
  end
end
