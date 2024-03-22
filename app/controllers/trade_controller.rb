class TradeController < ApplicationController
  skip_forgery_protection
  require_relative "../../lib/trading/trading_bot.rb"

  def start
    @client = initialize_alpaca_client("paper", "PKQS4UYIMUTPBVDY7BPC", "vDV0LSbYLPc6vSc9jWIXeAib9QYD7wgpNPgrVj4f")
    puts @client.account
  end
end
