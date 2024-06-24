class RenameTypeToTradeTypeInBotTrades < ActiveRecord::Migration[7.1]
  def change
    rename_column :bot_trades, :type, :trade_type
  end
end
