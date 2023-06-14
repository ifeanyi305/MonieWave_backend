class Transfer < ApplicationRecord
  belongs_to :user

  STATUS = %w[Pending Processing Completed Rejected].freeze

  validates :status, presence: true, inclusion: { in: STATUS }

  validates :currency, :naira_amount, :amount, :exchange_rate, :fee, :recipient_name,
            :recipient_account, :recipient_bank, :recipient_phone,
            :reference_number, :payment_method, presence: true
end
