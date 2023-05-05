class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    if @user.save
      render json: { user: UserSerializer.new(@user) }, status: :created
    else
      render json: { error: 'Failed to create user' }, status: :not_acceptable
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
