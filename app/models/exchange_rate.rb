class ExchangeRate < ApplicationRecord
  CURRENCIES = %w[euro pounds].freeze

  validates :price, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :time, presence: true
  validates :day, presence: true
  validates :month, presence: true
end
