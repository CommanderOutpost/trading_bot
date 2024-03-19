class AuthController < ApplicationController
  skip_forgery_protection

  def register
    if request.post?
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      if user.save
        flash[:notice] = "You have successfully registered"
        redirect_to :action => "login"
      else
        flash[:error] = "There was a problem registering"
      end
    end
  end

  def login
  end
end
