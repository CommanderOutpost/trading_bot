class HomeController < ApplicationController
  def index
    if session[:user_id] == nil
      @user = nil
    else
      @user = User.find(session[:user_id])
    end
  end
end
