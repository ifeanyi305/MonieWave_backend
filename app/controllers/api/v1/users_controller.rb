class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create forgot_password reset_password]
  before_action :check_admin, only: %i[index show create_super_user update_user_status update_user_role]
  before_action :verify_reset_password_params, only: %i[reset_password]
  # before_action :set_user, only: %i[show destroy]

  def index
    @users = User.select(:id, :email, :first_name, :last_name, :last_login, :status).as_json

    render json: { users: @users }, status: :ok
  end

  # Endpoint to create new user account
  def create
    @user = User.new(user_params)
    @user.role = 'customer'
    @user.status = 'Active'
    @user.last_login = DateTime.now

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
      # send a welcome email here
      UserMailer.with(user: @user).welcome_email.deliver_now
    else
      render json: { error: 'Failed to create user', message: @user.errors }, status: :not_acceptable
    end
  end

  # Endpoint to create new super user account
  def create_super_user
    @user = User.new(user_params)
    @user.status = 'Active'
    @user.last_login = DateTime.now

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
      # send a welcome email here
      UserMailer.with(user: @user).welcome_email.deliver_now
    else
      render json: { error: 'Failed to create user', message: @user.errors.full_messages }, status: :not_acceptable
    end
  end

  # Endpoint to get all the details of a given user
  def show
    @user = User.includes(:transfers, :beneficiaries).select(
      :id, :email, :first_name, :last_name, :last_login,
      :status, :verified, :role, :country
    ).find(params[:id])
    
    if @user
      @transfers = @user.transfers
      @beneficiaries = @user.beneficiaries

      render json: { user: @user, transfers: @transfers, beneficiaries: @beneficiaries }, status: :ok
    else
      render json: { error: @user.error, message: 'User not found' }, status: :not_found
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      render json: {message: "User deleted from database"}, status: :ok
    else
      render json: {error: "User not deleted"}, status: :unprocessable_entity
    end
  end

  # Endpoint to get password reset link
  def forgot_password
    return render json: { error: 'Email not present' }, status: :not_found if params[:email].blank?

    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_token!
      render json: { staus: 'ok', message: 'Password reset link sent' }, status: :ok
      UserMailer.with(user: @user).forgot_password_email.deliver_now
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  # Endpoint to change users password
  def reset_password
    @user = User.find_by(reset_password_token: params[:data][:token].to_s)

    if @user.present? && @user.password_token_valid?

      if @user.reset_password!(params[:data][:password])
        render json: { status: 'ok', message: 'Password changed successfully' }, status: :ok
        UserMailer.with(user: @user).password_reset_success_email.deliver_now
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  # Endpoint to update user's status
  def update_user_status
    @user = User.find_by(id: params[:user][:id])

    return render json: { error: "User not found" }, status: :not_found if @user.nil?

    @user.status = params[:user][:status]

    if @user.save
      render json: {message: "User status updated to #{params[:user][:status]}"}, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Endpoint to update user's role
  def update_user_role
    @user = User.find_by(id: params[:user][:id])

    return render json: { error: "User not found" }, status: :not_found if @user.nil?

    @user.role = params[:user][:role]

    if @user.save
      render json: {message: "User role updated to #{params[:user][:role]}"}, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def verify_reset_password_params
    return render json: { error: 'Token not present' }, status: :not_found if params[:data][:token].blank?
    return render json: { error: 'Email not present' }, status: :not_found if params[:data][:email].blank?

    return unless params[:data][:password].to_s.length < 8

    render json: { error: 'Password too short, Must be longer than 8 characters' },
           status: :not_acceptable
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :country, :verified, :role, :email, :password)
  end
end
