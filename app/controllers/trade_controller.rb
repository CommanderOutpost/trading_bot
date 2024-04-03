class TradeController < ApplicationController
  skip_forgery_protection
  require_relative "../../lib/trading/trading_bot.rb"

  @@bot_thread = nil
  @@bot_instance = nil

  def start
    begin
      # Retrieve user settings
      @settings = Setting.find_by(user_id: session[:user_id])

      # Ensure settings are found
      unless @settings
        flash[:error] = "Ensure you have configured your settings before starting the trading bot"
      end

      # Initialize trading bot with user settings
      api_key = @settings.key_id
      api_secret = @settings.key_secret
      api_endpoint = @settings.endpoint
      symbol = params[:stock].upcase

      if @settings.broker == "Alpaca"
        @@bot_instance = RealTimeTradingBot.new(api_key, api_secret, api_endpoint, symbol)
        @bot = true
      elsif @settings.broker == "Binance"
        flash[:error] = "Binance not supported...yet"
        redirect_to root_path
        return
      else
        flash[:error] = "Broker not supported"
        redirect_to root_path
        return
      end

      # Check if trade record already exists for the user and status is running
      existing_trade = Trade.find_by(user_id: session[:user_id], status: "running")

      if existing_trade
        flash[:error] = "Bot is already running"
        redirect_to root_path
        return
      end

      # Create a new trade record
      @trade = Trade.create!(
        user_id: session[:user_id],
        symbol: symbol,
        status: "running",
        quantity: @@bot_instance.get_quantity,
        initial_portfolio_value: @@bot_instance.get_portfolio[:portfolio_value],
        start_time: Time.zone.now,
        end_time: Time.zone.now + 1.day,
      )

      # Start the bot in a new thread
      Thread.new do
        @@bot_instance.run
      end

      redirect_to root_path
    rescue StandardError => e
      # Handle errors gracefully
      logger.error "Error starting trading bot: #{e}"
      flash[:error] = "An error occurred while starting the trading bot please ensure your settings are correct"
      redirect_to root_path
    end
  end

  def stop
    begin

      # Check if trade record already exists for the user and status is running
      existing_trade = Trade.find_by(user_id: session[:user_id], status: "running")

      unless existing_trade
        flash[:error] = "Bot is not running"
        redirect_to root_path
        return
      end

      # Stop the trading bot
      existing_trade.update!(status: "stopped", end_time: Time.zone.now)

      # Redirect to the dashboard
      redirect_to root_path
    rescue StandardError => e
      # Handle errors gracefully
      logger.error "Error stopping trading bot: #{e}"
      flash[:error] = "An error occurred while stopping the trading bot"
      redirect_to root_path
    end
  end
end
