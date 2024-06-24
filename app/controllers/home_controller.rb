require "httparty"

class HomeController < ApplicationController
  def index
    # Guard clause for when user is not logged in
    return @user = nil unless session[:user_id]

    # If session[:user_id] exists, find the user, settings, and running trade
    @user = User.find_by(id: session[:user_id])
    @settings = Setting.find_by(user_id: @user.id)
    @trade = Trade.find_by(user_id: @user.id, status: "running")

    # Check if API keys are set
    if @settings.nil? || @settings.key_id.blank? || @settings.key_secret.blank?
      flash[:error] = "Please set your API key and secret in settings."
      redirect_to settings_path and return
    end

    # Fetching predefined stocks
    response = HTTParty.get("http://localhost:5001/stocks",
                            headers: {
                              "APCA-API-KEY-ID" => @settings.key_id,
                              "APCA-API-SECRET-KEY" => @settings.key_secret,
                            })

    if response.code == 200
      @stocks = response.parsed_response
      # Rails.logger.info "Stocks retrieved successfully: #{@stocks}"
    else
      @stocks = []
      flash[:error] = "Failed to retrieve stock data: #{response.message}"
    end

    @bot_trades = BotTrade.all.order(transaction_time: :desc)
    puts @bot_trades
  end
end
