class FeeRange < ApplicationRecord
  validates :start_price, :end_price, :fee, presence: true
end
