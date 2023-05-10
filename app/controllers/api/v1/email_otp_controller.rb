class Api::V1::EmailOtpController < ApplicationController
  skip_before_action :authenticate_request, only: %i[get_otp verify_otp]
  require 'securerandom'

  def get_otp
    return render json: {message: "No email provided"} if params[:user][:email].nil?
    @email = EmailOtp.find_by(email: params[:user][:email])

    if @email.present?
      @email.otp = generate_otp
      @email.save!
      UserMailer.with(email: @email.email, otp: @email.otp).user_email_verification_email.deliver_now
      return render json: {status: 'ok', message: "OTP re-sent successfully"}, status: :ok
    else
      @email_otp = EmailOtp.new(email_otp_param)
      @email_otp.otp = generate_otp
      if @email_otp.save
        UserMailer.with(email: @email_otp.email, otp: @email_otp.otp).user_email_verification_email.deliver_now
        return render json: { status: 'ok', message: "OTP sent successfully" }, status: :ok
      else
        return render json: { error: 'otp not sent', message: @email_otp.errors }, status: :not_acceptable
      end
    end
  end

  def verify_otp
    return render json: { message: "No email provided" }, status: :not_found if params[:user][:email].nil?
    return render json: { message: "No OTP provided" }, status: :not_found if params[:user][:otp].nil?
    @user_otp = EmailOtp.find_by(email: params[:user][:email])

    if @user_otp.present? && @user_otp.otp == params[:user][:otp]
  
      render json: { message: "Email verification successfull" }, status: :ok
      @user_otp.destroy!
    else
      return render json: { error: "OTP Verification failed" }, status: :not_acceptable
    end
  end

  private
  def email_otp_param
    params.require(:user).permit(:email)
  end

  def generate_otp
    SecureRandom.random_number(1000000).to_s.rjust(6, "0")
  end

end
