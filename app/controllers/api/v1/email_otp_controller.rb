class Api::V1::EmailOtpController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create_otp verify_otp]
  require 'securerandom'

  # Endpoint to get email verification OTP
  def create_otp
    return render json: { message: 'No email provided' }, status: :not_acceptable if params[:user][:email].nil?

    @user = User.find_by(email: params[:user][:email])
    return render json: { message: 'There is an account with this email' }, status: :not_acceptable if @user.present?

    @email = EmailOtp.find_by(email: params[:user][:email])

    if @email.present?
      @email.otp = generate_otp
      @email.save!
      UserMailer.with(email: @email.email, otp: @email.otp).user_email_verification_email.deliver_now
      render json: { status: 'ok', message: 'OTP re-sent successfully' }, status: :ok
    else
      @email_otp = EmailOtp.new(email_otp_param)
      @email_otp.otp = generate_otp
      unless @email_otp.save
        return render json: { error: 'otp not sent', message: @email_otp.errors }, status: :not_acceptable
      end

      UserMailer.with(email: @email_otp.email, otp: @email_otp.otp).user_email_verification_email.deliver_now
      render json: { status: 'ok', message: 'OTP sent successfully' }, status: :ok

    end
  end

  # Endpoint to verify user OTP
  def verify_otp
    return render json: { message: 'No email provided' }, status: :not_found if params[:user][:email].nil?
    return render json: { message: 'No OTP provided' }, status: :not_found if params[:user][:otp].nil?

    @user_otp = EmailOtp.find_by(email: params[:user][:email])

    # return render json: {message: 'OTP expired' },
    # status: :not_acceptable if (@user_otp.updated_at + 5.minutes) > Time.now.utc
    # return render(json: { message: 'OTP expired' },
    # status: :not_acceptable) if (@user_otp.updated_at + 2.minutes) > Time.now.utc

    unless @user_otp.present? && @user_otp.otp == params[:user][:otp]
      return render json: { error: 'OTP Verification failed' }, status: :not_acceptable
    end

    render json: { message: 'Email verification successfull' }, status: :ok
    @user_otp.destroy!
  end

  private

  def email_otp_param
    params.require(:user).permit(:email)
  end

  def generate_otp
    SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
  end
end
