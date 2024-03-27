class HomeController < ApplicationController
  def index
    if session[:user_id] == nil
      @user = nil
    else
      @user = User.find(session[:user_id])
      @settings = Setting.find_by(user_id: session[:user_id])
      @trade = Trade.find_by(user_id: session[:user_id], status: "running")

      if @settings.nil?
        flash[:error] = "Please set your API key and secret in settings"
      end
    end
  end
end
