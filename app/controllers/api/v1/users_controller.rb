class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
    else
      render json: { error: 'Failed to create user', message: @user.errors }, status: :not_acceptable
    end
  end
  
  private

  def user_params
    params.permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
