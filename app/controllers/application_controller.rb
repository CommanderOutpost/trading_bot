class ApplicationController < ActionController::Base
  # Assuming @@bot_instance is accessible here or you have a way to access the bot instance
  bot_instance = TradeController.bot_instance

  def self.stop_all_trading_activities
    # Stop the trading bot
    bot_instance&.stop
    puts "Trading bot stopped"

    # Update all running trades to 'stopped'
    Trade.where(status: "running").update_all(status: "stopped", end_time: Time.zone.now)
  end
end
