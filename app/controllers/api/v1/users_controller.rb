class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create forgot_password reset_password]
  before_action :check_admin, only: %i[index]
  before_action :verify_reset_password_params, only: %i[reset_password]
  # before_action :set_user, only: %i[show destroy]

  def index
    @users = User.all
    render json: { users: @users }, status: :ok
  end

  def create
    @user = User.new(user_params)
    @user.role = 'customer'

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
      # send a welcome email here
      UserMailer.with(user: @user).welcome_email.deliver_now
    else
      render json: { error: 'Failed to create user', message: @user.errors }, status: :not_acceptable
    end
  end

  def forgot_password
    return render json: { error: 'Email not present' } if params[:email].blank?

    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_token!
      render json: { staus: 'ok', message: 'Password reset link sent' }, status: :ok
      UserMailer.with(user: @user).forgot_password_email.deliver_now
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  def reset_password
    @user = User.find_by(reset_password_token: params[:token].to_s)

    if @user.present? && @user.password_token_valid?

      if @user.reset_password!(params[:password])
        render json: { status: 'ok', message: 'Password changed successfully' }, status: :ok
        UserMailer.with(user: @user).password_reset_success_email.deliver_now
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  private

  def verify_reset_password_params
    return render json: { error: 'Token not present' } if params[:token].blank?
    return render json: { error: 'Email not present' } if params[:email].blank?

    return unless params[:password].to_s.length < 8

    render json: { error: 'Password too short, Must be longer than 8 characters' }
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
