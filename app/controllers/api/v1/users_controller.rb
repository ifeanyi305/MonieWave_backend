class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create, forgot_password]
  before_action :check_admin, only: %i[index]
  # before_action :set_user, only: %i[show destroy]

  def index
    @users = User.all
    render json: { users: @users }, status: :ok
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
      # send a welcome email here
      UserMailer.with(user: @user).welcome_email.deliver_now
    else
      render json: { error: 'Failed to create user', message: @user.errors }, status: :not_acceptable
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
