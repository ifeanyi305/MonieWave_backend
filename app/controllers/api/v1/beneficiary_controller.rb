class Api::V1::BeneficiaryController < ApplicationController

  def index
    @beneficiaries = @current_user.beneficiaries

    if @beneficiaries.present?
      render json: { data: @beneficiaries }, status: :ok
    else
      render json: { message: "No beneficiary found" }, status: :not_found
    end
  end

  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    @beneficiary.user = @current_user

    if @beneficiary.save
      render json: { message: "Beneficiary added successfullly" }, status: :created
    else
      render json: { message: "Couldn't create beneficiary", error: @beneficiary.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @beneficiary = Beneficiary.find(params[:id])

    if @beneficiary.destroy! 
      render json: { message: "Beneficiary deleted successfully" }, status: :ok
    else
      render json: { message: "Failed to delete beneficiary", error: @beneficiary.errors }, status: :not_found
    end
  end

  private

  def beneficiary_params
    params.require(:data).permit(:bank_name, :account_number, :account_name, :phone_number)
  end
  
end
