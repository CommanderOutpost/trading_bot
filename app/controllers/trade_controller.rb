class TradeController < ApplicationController
  skip_forgery_protection
  require_relative "../../lib/trading/real_time_trading_bot.rb"

  def start
    puts "Trade started"
    puts RealTimeTradingBot.run
  end
end
