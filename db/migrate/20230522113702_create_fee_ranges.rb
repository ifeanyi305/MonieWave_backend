class CreateFeeRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :fee_ranges do |t|
      t.integer :start_price
      t.integer :end_price
      t.float :fee

      t.timestamps
    end
  end
end
