# app/controllers/concerns/trading_bot_manageable.rb
module Trade::TradingBotManageable
  extend ActiveSupport::Concern
  require_relative "../../../../lib/trading/alpaca_trading_bot.rb"

  @@bot_instance = nil

  included do
    skip_forgery_protection
    before_action :load_user_settings
  end

  def self.bot_instance
    @@bot_instance
  end

  def start
    return handle_error("No settings specified") unless settings_present?
    return handle_error("Broker not supported") unless supported_broker?

    if bot_already_running?
      flash[:error] = "Bot is already running"
      return redirect_to root_path
    end

    initialize_trading_bot(params[:stock].upcase)
    create_trade_record
    start_bot_thread

    redirect_to root_path
  rescue StandardError => e
    handle_error("Error starting trading bot: #{e}")
  end

  def stop
    unless bot_already_running?
      flash[:error] = "Bot is not running"
      return redirect_to root_path
    end

    stop_trading_bot
    redirect_to root_path
  rescue StandardError => e
    handle_error("Error stopping trading bot: #{e}")
  end

  private

  def bot_already_running?
    Trade.exists?(user_id: session[:user_id], status: "running")
  end

  def initialize_trading_bot(symbol)
    api_key = @settings.key_id
    api_secret = @settings.key_secret
    api_endpoint = @settings.endpoint
    callback = -> { stop_trading_bot }

    @@bot_instance = RealTimeAlpacaTradingBot.new(api_key, api_secret, api_endpoint, symbol, callback) if @settings.broker == "Alpaca"
  end

  def create_trade_record
    Trade.create!(
      user_id: session[:user_id],
      symbol: params[:stock].upcase,
      status: "running",
      quantity: @@bot_instance.get_attributes[:quantity],
      initial_portfolio_value: @@bot_instance.get_portfolio[:portfolio_value],
      start_time: Time.zone.now,
      end_time: Time.zone.now + 1.day,
    )
  end

  def start_bot_thread
    Thread.new { @@bot_instance.run }
  end

  def stop_trading_bot
    Trade.where(user_id: session[:user_id], status: "running").update_all(status: "stopped", end_time: Time.zone.now)
  end

  def load_user_settings
    @settings = Setting.find_by(user_id: session[:user_id])
  end

  def handle_error(message)
    if message.nil?
      message = "An error occurred; please ensure your settings are correct."
    end

    flash[:error] = message
    logger.error message

    redirect_to root_path
  end

  def supported_broker?
    @settings.broker.in?(["Alpaca"])
  end

  def settings_present?
    unless @settings
      flash[:error] = "Ensure you have configured your settings before starting the trading bot"
      return false
    end
    true
  end
end
