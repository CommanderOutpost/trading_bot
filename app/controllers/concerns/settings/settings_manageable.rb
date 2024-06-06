# app/controllers/concerns/settings_manageable.rb
module Settings::SettingsManageable
  extend ActiveSupport::Concern

  included do
    skip_forgery_protection
    before_action :load_or_initialize_settings, only: [:create]
    before_action :set_user_and_settings, only: [:index]
  end

  def create
    assign_settings_from_params

    if @settings.save
      redirect_to root_path
    else
      flash[:error] = "There was a problem saving your settings"
      render :new
    end
  end

  def index
  end

  def new
    @settings = Setting.new
  end

  def show
    redirect_to root_path
  end

  private

  def assign_settings_from_params
    @settings.attributes = {
      key_id: params[:api_key],
      key_secret: params[:api_secret],
      endpoint: get_api_endpoint(params[:account_type]),
      user_id: session[:user_id],
      broker: params[:broker],
    }
  end

  def load_or_initialize_settings
    @settings = Setting.find_or_initialize_by(user_id: session[:user_id])
  end

  def set_user_and_settings
    @settings = Setting.find_by(user_id: session[:user_id])
    @user = User.find(session[:user_id])
  end

  def get_api_endpoint(account_type)
    case account_type
    when "paper"
      "https://paper-api.alpaca.markets"
    when "live"
      "https://api.alpaca.markets"
    else
      "https://paper-api.alpaca.markets"
    end
  end
end
