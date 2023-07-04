class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.string :sender

      t.timestamps
    end
  end
end
