class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
