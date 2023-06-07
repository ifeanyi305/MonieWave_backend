class Api::V1::TransfersController < ApplicationController
  before_action :check_admin, only: %i[update_transfer_status]

  def index
    @transfers = @current_user.transfers

    if @transfers.present?
      render json: { data: @transfers }, status: :ok
    else
      render json: { message: 'You have not completed any transfer yet ' }, status: :not_found
    end
  end

  def create
    @transfer = Transfer.new(transfer_params)
    @transfer.user = @current_user
    @transfer.status = 'Pending'

    if @transfer.save
      render json: { message: 'Transfer success, Pending confirmation' }, status: :created
    else
      render json: { message: 'Could not complete transfer', error: @transfer.errors }, status: :unprocessable_entity
    end
  end

  def update_transfer_status
    @transfer = Transfer.find(params[:data][:id])
    
    @transfer.status = params[:data][:status]
    if @transfer.save!
      #sender user email informing them of the update
      render json: { message: "Transfer status update to #{params[:data][:status]} successfully"}, status: :ok
    else
      render json: { error: @transfer.error, message: 'Status not updated'}, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.require(:data).permit(:currency, :naira_amount, :amount, :exchange_rate, :recipient_name,
                                 :recipient_account, :recipient_bank, :recipient_phone,
                                 :reference_number, :payment_method)
  end
end
