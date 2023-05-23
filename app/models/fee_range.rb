class FeeRange < ApplicationRecord
  validates :start_price, :end_price, :fee, presence: true
  validates :start_price,
            uniqueness: { scope: :end_price, message: 'combination of start_price and end_price already exists' }
end
