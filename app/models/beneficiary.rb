class Beneficiary < ApplicationRecord
  belongs_to :user

  validates :bank_name, :account_number, :account_name, :phone_number, presence: true
end
