class Api::V1::BeneficiaryController < ApplicationController
  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    @beneficiary.user = @current_user

    if @beneficiary.save
      render json: { message: "Beneficiary added successfullly" }, status: :created
    else
      render json: { message: "Couldn't create beneficiary", error: @beneficiary.errors }, status: :unprocessable_entity
    end
  end

  private

  def beneficiary_params
    params.require(:data).permit(:bank_name, :account_number, :account_name, :phone_number)
  end
  
end
