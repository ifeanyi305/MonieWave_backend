class Api::V1::ChatsController < ApplicationController
  before_action :check_admin, only: %i[index destroy]

  def index
    @chats = Chat.where(admin_id: @current_user.id).includes(:user, :messages)

    if @chats.present?
      chat_data = @chats.map do |chat|
        {
          
          user_details: { chat_id: chat.id, time: chat.updated_at, user_id: chat.user_id, email: chat.user.email, name: chat.user.first_name }
        }
      end
      render json: { chats: chat_data }, status: :ok
    else
      render json: { data: 'No chat found' }, status: :not_found
    end
  end
  
  def show
    if @current_user.admin?
      @chat = Chat.find_by(id: params[:id])
    else
      # @chat = @current_user.chats.find_by(id: params[:id])
      @chat = @current_user.chats.first
    end
    
    if @chat.present?
      @messages = @chat.messages.includes(:user, :admin)
    
      render json: { messages: @messages }, status: :ok
    else
      render json: { data: 'No chat found'  }, status: :not_found
    end
  end
  

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
      render json: { error: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

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
