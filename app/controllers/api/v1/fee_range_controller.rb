class Api::V1::FeeRangeController < ApplicationController
  before_action :check_admin, only: %i[create]
  
  def create
    @transaction_fee = FeeRange.new(fee_params)
    if @transaction_fee.start_price < @transaction_fee.end_price
      return render json: { message: 'Start price cannot be greater than End price' },
                    status: :not_acceptable
    end

    if @transaction_fee.save
      render json: {message: "Fee added successfully" }, status: :created
    else
      render json: {message: "Fee creation failed", error: @transaction_fee.errors}, status: :unprocessable_entity
    end
  end

  private

  def fee_params
    params.require(:data).permit(:start_price, :end_price, :fee)
  end
end
