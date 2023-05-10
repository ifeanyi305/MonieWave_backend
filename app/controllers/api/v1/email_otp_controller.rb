class Api::V1::EmailOtpController < ApplicationController
  skip_before_action :authenticate_request, only: %i[get_otp verify_otp]
  require 'securerandom'

  def get_otp
    return render json: {message: "No email provided"} if params[:user][:email].nil?
    @email = EmailOtp.find_by(email: params[:user][:email])

    if @email.present?
      @email.otp = generate_otp
      @email.save!
      #send email here
      UserMailer.with(email: @email.email, otp: @email.otp).user_email_verification_email.deliver_now
      return render json: {status: 'ok', message: "OTP re-sent successfully"}, status: :ok
    else
      @email_otp = EmailOtp.new(email_otp_param)
      @email_otp.otp = generate_otp
      if @email_otp.save
        #send email here
        UserMailer.with(email: @email_otp.email, otp: @email_otp.otp).user_email_verification_email.deliver_now
        return render json: {status: 'ok', message: "OTP sent successfully"}, status: :ok
      else
        return render json: { error: 'otp not sent', message: @email_otp.errors }, status: :not_acceptable
      end
    end

  end

  # def verify_otp
  #   user_otp = Otp.find_by(email: params[:user][:email])

  #   if user_otp.present?
  #     if user_otp.token = params[:user][:otp]
  #       return success
  #       otp does not match//


  # end

  private
  def email_otp_param
    params.require(:user).permit(:email)
  end

  def generate_otp
    SecureRandom.random_number(1000000).to_s.rjust(6, "0")
  end

end
