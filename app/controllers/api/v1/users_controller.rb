class Api::V1::UsersController < ApplicationController

  def create
    p user_params
    @user = User.new(user_params)
    puts @user.reset_password_token
    puts "hello"
    puts @user.password
    if @user.save
      render json: { user: UserSerializer.new(@user) }, status: :created
    else
      render json: { error: 'Failed to create user', message: @user.errors }, status: :not_acceptable
    end
  end
  
  private

  def user_params
    params.permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
