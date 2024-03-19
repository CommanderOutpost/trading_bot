# The AuthController handles user authentication and registration.
class AuthController < ApplicationController
  skip_forgery_protection

  # Registers a new user.
  def register
    if request.post?
      @user = User.new(
        params[:user]
      )
      @user.password = params[:password]
      if @user.save
        flash[:notice] = "You have successfully registered"
        redirect_to :action => "login"
      else
        flash[:error] = "There was a problem registering"
      end
    end
  rescue StandardError => e
    flash[:error] = "An error occurred: #{e.message}"
    redirect_to :action => "login"
  end

  # Logs in a user.
  def login
    if request.post?
      @user = User.find_by(username: params[:username])&.authenticate(params[:password])
    end
  rescue StandardError => e
    flash[:error] = "An error occurred: #{e.message}"
    redirect_to :action => "login"
  end
end
