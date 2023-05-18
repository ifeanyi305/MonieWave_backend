class Api::V1::ExchangeRateController < ApplicationController
  require 'date'
  skip_before_action :authenticate_request, only: %i[]
  before_action :check_admin, only: %i[create]

  def create
    @exchange_rate = ExchangeRate.new(rate_params)
    @exchange_rate.time = DateTime.now
    @exchange_rate.day = Time.now.day
    @exchange_rate.month = Time.now.month

    if @exchange_rate.save
      return render json: { message: "New exchange rate added successfully" }, status: :created
    else
      return render json: { message: "Exchange rate update failed" }, status: :unprocessable_entity
    end
  end
  
  def rate_params
    params.require(:data).permit(:currency, :price)
  end
end
