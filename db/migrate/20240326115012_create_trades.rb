class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.integer :user_id
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.decimal :initial_portfolio_value, null: false
      t.decimal :final_portfolio_value
      t.string :status, null: false
      t.string :symbol, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
