class ChatMailer < ApplicationMailer
  default from: email_address_with_name('support@ratehive.com', 'RATEHIVE OFFICIAL')

  def new_chat_email
    @admin = params[:admin]
    mail(
      to: email_address_with_name(@admin.email, @admin.first_name),
      subject: 'You have a new chat'
    )
  end
end
