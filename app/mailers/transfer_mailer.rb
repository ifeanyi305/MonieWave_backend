class TransferMailer < ApplicationMailer
  # default from: 'support@ratehive.com'
  default from: email_address_with_name('valentine6586@gmail.com', 'RATEHIVE OFFICIAL')

  def success_email
    @user = params[:user]
    @amount = params[:amount]
    @recipient = params[:recipient]
    @currency = params[:currency]
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Transfer Initiated!'
    )
  end

  def tranfer_proccessing_email
    @user = params[:user]
    @recipient = params[:recipient]
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Transfer recieved, Proccessing payments to recipient'
    )
  end

  def tranfer_completed_email
    @user = params[:user]
    @recipient = params[:recipient]
    @naira_amount = params[:naira_amount]
    @amount = params[:amount]
    @currency = params[:currency]
    mail(
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'Transfer Successful: Funds Delivered!'
    )
  end
end
