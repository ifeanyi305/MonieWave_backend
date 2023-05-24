class Api::V1::TransfersController < ApplicationController

  def index
    @transfers = @current_user.transfers

    if @transfers.present?
      render json: { data: @transfer }, status: :ok
    else
      render json: { message: "You have not completed any transfer yet " }, status: :not_found
    end
  end

  def create
    @transfer = Transfer.new(transfer_params)
    @transfer.user = @current_user
    @transfer.status = "Pending"

    if @transfer.save
      render json: { message: "Transfer success, Pending confirmation" }, status: :created
    else
      render json: { message: "Could not complete transfer", error: @transfer.errors }, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.require(:data).permit(:currency, :naira_amount, :amount, :exchange_rate, :recipient_name,
                                 :recipient_account, :recipient_bank, :recipient_phone,
                                 :reference_number, :payment_method)
  end
end