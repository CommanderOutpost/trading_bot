class TradeController < ApplicationController
  skip_forgery_protection
  require_relative "../../lib/trading/real_time_trading_bot"

  def start
    begin
      # Retrieve user settings
      @settings = Setting.find_by(user_id: session[:user_id])

      # Ensure settings are found
      unless @settings
        flash[:error] = "User settings not found"
        redirect_to root_path
        return
      end

      # Initialize trading bot with user settings
      api_key = @settings.key_id
      api_secret = @settings.key_secret
      api_endpoint = @settings.endpoint
      symbol = @settings.trading_symbol
      @bot = RealTimeTradingBot.new(api_key, api_secret, api_endpoint, symbol)

      # Run the trading bot
      @bot.run
    rescue StandardError => e
      # Handle errors gracefully
      logger.error "Error starting trading bot: #{e.message}"
      flash[:error] = "An error occurred while starting the trading bot"
      redirect_to root_path
    end
  end
end
