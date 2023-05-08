class UserMailer < ApplicationMailer
  # default from: 'support@ratehive.com'
  default from: email_address_with_name('valentine6586@gmail.com', 'RATEHIVE OFFICIAL')

  def welcome_email
    @user = params[:user]
    @url  = 'https://ratehive.com/login'
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Welcome to RATEHIVE'
    )
  end

  def forgot_password_email
    @user = params[:user]
    @url = "https://ratehive.com/reset_password?token=#{@user.reset_password_token}"
  end
end
