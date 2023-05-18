class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.string :currency
      t.float :price
      t.datetime :time
      t.string :day
      t.string :month

      t.timestamps
    end
  end
end
