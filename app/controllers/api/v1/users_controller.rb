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

  def forgot_password
    if params[:email].blank?
      return render json: {error: 'Email not present' }
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.generate_password_token!

      puts user.reset_password_token
      puts user.reset_password_sent_at
      #send email here
      render json: {staus: "ok", message: "Password reset link sent"}, status: :ok
    else
      render json: {error: "Email address not found. Please check and try again."}, status: :not_found
    end
  end

  def reset_password

  end

  private

  def user_params
    params.permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
