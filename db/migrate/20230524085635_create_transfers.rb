class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.string :currency
      t.string :amount
      t.string :naira_amount
      t.integer :exchange_rate
      t.string :fee
      t.string :recipient_name
      t.text :recipient_account
      t.string :recipient_bank
      t.string :recipient_phone
      t.string :reference_number
      t.string :payment_method
      t.string :status
      t.timestamp :processing_time, null: true
      t.timestamp :completed_time, null: true
      t.timestamp :rejected_time, null: true

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
