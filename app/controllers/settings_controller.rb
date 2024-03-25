class SettingsController < ApplicationController
  skip_forgery_protection

  def create
    api_key = params[:api_key]
    api_secret = params[:api_secret]
    account_type = params[:account_type]
    user_id = session[:user_id]

    api_endpoint = get_api_endpoint(account_type)

    # Check if the setting already exists
    @settings = Setting.find_by(user_id: user_id)

    if @settings.nil?
      # If setting does not exist, create a new one
      @settings = Setting.new(key_id: api_key, key_secret: api_secret, endpoint: api_endpoint, user_id: user_id)
    else
      # If setting exists, update it
      @settings.key_id = api_key
      @settings.key_secret = api_secret
      @settings.endpoint = api_endpoint
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
    puts @settings.inspect
  end

  def new
    @settings = Setting.new
  end

  # def update
  #   api_key = params[:api_key]
  #   api_secret = params[:api_secret]
  #   account_type = params[:account_type]
  #   id = params[:id]
  #   api_secret = "bodyy"

  #   puts api_key + " " + api_secret + " " + account_type + " " + id

  #   api_endpoint = get_api_endpoint(account_type)

  #   @settings = Setting.find_by(id: id)
  #   @settings.key_id = api_key
  #   @settings.key_secret = api_secret
  #   @settings.endpoint = api_endpoint

  #   if @settings.save!
  #     redirect_to root_path
  #   else
  #     flash[:error] = "There was a problem saving your settings"
  #   end
  # end

  def show
    redirect_to settings_path
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
