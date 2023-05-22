class Api::V1::ExchangeRateController < ApplicationController
  require 'date'
  skip_before_action :authenticate_request, only: %i[last_currency_rate all_last_rate all_rates_data]
  before_action :check_admin, only: %i[create]

  # Endpoint to create a new exchange rate
  def create
    @exchange_rate = ExchangeRate.new(rate_params)
    @exchange_rate.time = DateTime.now
    @exchange_rate.day = Time.now.strftime('%A')
    @exchange_rate.month = Time.now.strftime('%B')

    return render json: { message: 'New exchange rate added successfully' }, status: :created if @exchange_rate.save

    render json: { message: 'Exchange rate update failed', error: @exchange_rate.errors },
           status: :unprocessable_entity
  end

  # Endpoint to get latest exchange rate for a given currency
  def last_currency_rate
    @currency_rate = ExchangeRate.where(currency: params[:data][:currency]).order(created_at: :desc).first

    unless @currency_rate
      return render json: { message: "No exchange rate found for #{params[:currency]}." }, status: :not_found
    end

    render json: { message: "Latest #{params[:currency]} rate", data: @currency_rate }, status: :ok
  end

  # Endpoint to get latest exchange rate for euro and pounds
  def all_last_rate
    @euro_rate = ExchangeRate.where(currency: 'euro').order(created_at: :desc).first
    @pounds_rate = ExchangeRate.where(currency: 'pounds').order(created_at: :desc).first

    return render json: { message: 'No exchange rate found.' }, status: :not_found unless @euro_rate && @pounds_rate

    render json: { message: 'Latest rates', data: { Euro: @euro_rate, Pounds: @pounds_rate } }, status: :ok
  end

  # Endpoint to get the history data for euro and pounds
  def all_rates_data
    euro_rates = ExchangeRate.where(currency: 'euro')
    pounds_rates = ExchangeRate.where(currency: 'pounds')
    unless euro_rates.any? && pounds_rates.any?
      return render json: { message: 'No exchange rate found.' }, status: :not_found
    end

    render json: { message: 'All rates history data', data: { Euro: euro_rates, Pounds: pounds_rates } }, status: :ok
  end

  private

  def rate_params
    params.require(:data).permit(:currency, :price)
  end
end
