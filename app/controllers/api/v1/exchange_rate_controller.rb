class Api::V1::ExchangeRateController < ApplicationController
  require 'date'
  skip_before_action :authenticate_request, only: %i[eur_rate]
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

  def get_last_currency_rate
    @currency_rate = ExchangeRate.where(currency: params[:currency]).order(created_at: :desc).first

    if @currency_rate
      render json: {message: "Latest #{params[:currency]} rate", data: @currency_rate }, status: :ok
    else
      return render json: { message: "No exchange rate found for #{params[:currency]}." }, status: :not_found
    end
  end

  def get_all_last_rate
    @euro_rate = ExchangeRate.where(currency: 'euro').order(created_at: :desc).first
    @pounds_rate = ExchangeRate.where(currency: 'pounds').order(created_at: :desc).first

    if @euro_rate && @pounds_rate
      render json: {message: 'Latest rates', data: {Euro: @euro_rate, Pounds: @pounds_rate } }, status: :ok
    else
      return render json: { message: "No exchange rate found." }, status: :not_found
    end
  end

  
  def rate_params
    params.require(:data).permit(:currency, :price)
  end
end
