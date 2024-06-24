class CreateBotTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :bot_trades do |t|
      t.integer :user_id
      t.string :symbol
      t.string :type
      t.decimal :price
      t.integer :quantity
      t.string :status
      t.datetime :transaction_time

      t.timestamps
    end
  end
end
