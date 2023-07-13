class Api::V1::ChatsController < ApplicationController
  before_action :check_admin, only: %i[index destroy]

  # Endpoint for admin to view all the chat assigned to specific admin
  def index
    @chats = Chat.where(admin_id: @current_user.id).includes(:user, :messages)

    if @chats.present?
      chat_data = @chats.map do |chat|
        {

          user_details: { chat_id: chat.id, time: chat.updated_at, user_id: chat.user_id, email: chat.user.email,
                          name: chat.user.first_name }
        }
      end
      render json: { chats: chat_data }, status: :ok
    else
      render json: { data: 'No chat found' }, status: :not_found
    end
  end

  # endpoint to get the all the messages for a chat
  def show
    @chat = if @current_user.admin?
              Chat.find_by(id: params[:id])
            else
              @current_user.chats.first
            end

    if @chat.present?
      @messages = @chat.messages.includes(:user, :admin)

      render json: { messages: @messages }, status: :ok
    else
      render json: { data: 'No chat found' }, status: :not_found
    end
  end

  # Endpoint to create a new chat and add new message to existing chat
  def create
    @chat = if params[:data][:sender] == 'admin'
              Chat.find_by(user_id: params[:data][:user_id])
            else
              @current_user.chats.first
            end

    if @chat.present?
      @message = @chat.messages.build(chat_params.merge(user_id: @chat.user_id, admin_id: @chat.admin_id))
    else
      random_admin = User.random_admin
      @chat = Chat.create(user_id: @current_user.id, admin_id: random_admin.id)
      @message = @chat.messages.build(chat_params.merge(user_id: @current_user.id, admin_id: random_admin.id))
      # Send an email to the admin assigned to the chat
      ChatMailer.with(admin: random_admin).new_chat_email.deliver_now
    end

    if @message.save
      render json: { messages: @chat.messages }, status: :ok
    else
      render json: { error: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Endpoint to close a chat and delete all the messages of that chat from the database
  def destroy
    @chat = Chat.find_by(id: params[:id])

    if @chat.destroy
      @chat.messages.destroy_all
      render json: { message: 'Chat and messages deleted from database' }, status: :ok
    else
      render json: { error: 'Chat not deleted' }, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:data).permit(:content, :sender)
  end
end
