class SettingsController < ApplicationController
  skip_forgery_protection

  def create
    api_key = params[:api_key]
    api_secret = params[:api_secret]
    account_type = params[:account_type]
    user_id = session[:user_id]
    broker = params[:broker]

    api_endpoint = get_api_endpoint(account_type)

    # Check if the setting already exists
    @settings = Setting.find_by(user_id: user_id)

    if @settings.nil?
      # If setting does not exist, create a new one
      @settings = Setting.new(key_id: api_key, key_secret: api_secret, endpoint: api_endpoint, user_id: user_id, broker: broker)
    else
      # If setting exists, update it
      @settings.key_id = api_key
      @settings.key_secret = api_secret
      @settings.endpoint = api_endpoint
      @settings.broker = broker
    end

    if @settings.save
      redirect_to root_path
    else
      flash[:error] = "There was a problem saving your settings"
      render :new # Assuming there's a new action where the form is displayed
    end
  end

  def index
    @settings = Setting.find_by(user_id: session[:user_id])
    @user = User.find(session[:user_id])
  end

  def new
    @settings = Setting.new
  end

  def show
    redirect_to root_path
  end

  private

  def get_api_endpoint(account_type)
    if account_type == "paper"
      return "https://paper-api.alpaca.markets"
    elsif account_type == "live"
      return "https://api.alpaca.markets"
    else
      return "https://paper-api.alpaca.markets"
    end
  end
end
