class Api::V1::TransfersController < ApplicationController
  before_action :check_admin, only: %i[update_transfer_status show show_all_transfers]

  # Endpoint to get a users transfers
  def index
    @transfers = @current_user.transfers

    if @transfers.present?
      render json: { data: @transfers }, status: :ok
    else
      render json: { message: 'You have not completed any transfer yet ' }, status: :not_found
    end
  end

  # Endpoint to create a new transfer
  def create
    @transfer = Transfer.new(transfer_params)
    @transfer.user = @current_user
    @transfer.status = 'Pending'

    if @transfer.save
      render json: { message: 'Transfer success, Pending confirmation' }, status: :created
      TransferMailer.with(
        user: @transfer.user, amount: @transfer.amount,
        recipient: @transfer.recipient_name, currency: @transfer.currency
      ).success_email.deliver_now
    else
      render json: { message: 'Could not complete transfer', error: @transfer.errors }, status: :unprocessable_entity
    end
  end

  # Admin enpoint to get the details of a given transfer
  def show
    @transfer = Transfer.includes(:user).find_by(id: params[:id])

    if @transfer.present?
      transfer_data = @transfer.attributes
      transfer_data['first_name'] = @transfer.user.first_name
      render json: { transfer: transfer_data }, status: :ok
    else
      render json: { error: 'Transfer not found' }, status: :not_found
    end
  end

  # Admin endpoint to see all users transfers
  def show_all_transfers
    @transfers = Transfer.select('transfers.id, transfers.created_at,
      transfers.amount, transfers.currency, transfers.status, users.first_name, users.last_name')
      .joins(:user)

    if @transfers.present?
      render json: { transfers: @transfers.as_json }, status: :ok
    elsif @transfers.empty?
      render json: { message: 'NO transfer yet' }, status: :not_found
    else
      render json: { error: 'Error occurred while fetching transfers' }, status: :unprocessable_entity
    end
  end

  # Admin endpoint to update the status of a transfer
  def update_transfer_status
    @transfer = Transfer.find(params[:data][:id])

    @transfer.status = params[:data][:status]
    status_time = "#{params[:data][:status]}_time"
    @transfer[status_time.downcase] = Time.now.utc
    if @transfer.save!
      render json: { message: "Transfer status updated to #{params[:data][:status]} successfully" }, status: :ok
      # sender user email informing them of the update
      transfer_status(@transfer)
    else
      render json: { error: @transfer.error, message: 'Status not updated' }, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.require(:data).permit(:currency, :naira_amount, :amount, :exchange_rate, :recipient_name,
                                 :recipient_account, :recipient_bank, :recipient_phone,
                                 :reference_number, :payment_method, :fee)
  end

  def transfer_status(transfer)
    case transfer.status
    when 'Processing'
      # send proccessing email
      # TransferMailer.with(user: transfer.user,recipient: transfer.recipient_name).tranfer_proccessing_email.deliver_now
    when 'Completed'
      # send completed email
      TransferMailer.with(user: transfer.user, amount: transfer.amount, currency: transfer.currency, recipient: transfer.recipient_name,
                          naira_amount: transfer.naira_amount).tranfer_completed_email.deliver_now
    when 'Rejected'
      # send Rejected email
    end
  end
end
