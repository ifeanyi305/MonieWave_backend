class UserMailer < ApplicationMailer
  # default from: 'support@ratehive.com'
  default from: email_address_with_name('valentine6586@gmail.com', 'RATEHIVE OFFICIAL')

  def welcome_email
    @user = params[:user]
    @url = 'https://ratehive.com/login'
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Welcome to RATEHIVE'
    )
  end

  def forgot_password_email
    @user = params[:user]
    @url = "https://ratehive.com/reset_password?token=#{@user.reset_password_token}&email=#{@user.email}"
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Reset your password'
    )
  end

  def password_reset_success_email
    @user = params[:user]
    @url = 'https://ratehive.com/login'
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Password reset successful'
    )
  end

  def user_email_verification_email
    @email = params[:email]
    @otp = params[:otp]
    mail(
      to: @email,
      subject: 'Account verification OTP'
    )
  end

  def user_account_status_change
    @email = params[:email]
    @status = params[:status]
    mail(
      to: @email,
      subject: 'Your account status was changed'
    )
  end
end
