class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:user][:email])
    if @user&.authenticate(params[:user][:password])
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :ok
    else
      render json: { errors: 'unauthorized' }, status: :unauthorized
    end
  end
end
