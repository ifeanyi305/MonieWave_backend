class Api::V1::ChatsController < ApplicationController
  def create
    if params[:data][:sender] == 'admin'
      @chat = Chat.find_by(user_id: params[:data][:user_id])
    else
      @chat = @current_user.chats.first
    end

    if @chat.present?
      @message = @chat.messages.build(chat_params.merge(user_id: @chat.user_id, admin_id: @chat.admin_id))
    else
      random_admin = User.random_admin
      @chat = Chat.create(user_id: @current_user.id, admin_id: random_admin.id)
      @message = @chat.messages.build(chat_params.merge(user_id: @current_user.id, admin_id: random_admin.id))
      #Send an email to the admin assigned to the chat
    end

    if @message.save
      render json: { messages: @chat.messages, chat: @chat }, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def chat_params
    params.require(:data).permit(:content, :sender)
  end
end
