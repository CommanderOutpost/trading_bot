class HomeController < ApplicationController
  def index
    # Guard clause for when user is not logged in
    return @user = nil unless session[:user_id]

    # If session[:user_id] exists, find the user, settings, and running trade
    @user = User.find_by(id: session[:user_id])
    @settings = Setting.find_by(user_id: session[:user_id])
    @trade = Trade.find_by(user_id: session[:user_id], status: "running")

    # Set flash error if settings are not present
    flash[:error] = "Please set your API key and secret in settings" if @settings.nil?

    # Predefined stocks
    @stocks = ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "FB", "BABA", "NFLX", "ORCL", "IBM"]
  end
end
