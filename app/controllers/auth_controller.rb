class AuthController < ApplicationController
  skip_forgery_protection
  before_action :set_user, only: [:login]

  def register
    return unless request.post?
    @user = User.new(user_params)
    if User.exists?(username: @user.username)
      redirect_to auth_login_path, flash: { error: "Username already exists" }
    elsif @user.save
      redirect_to auth_login_path
    else
      flash.now[:error] = "There was a problem registering"
      render :register
    end
  end

  def login
    return unless request.post?
    if @user
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to auth_login_path, flash: { error: "Invalid username or password" }
    end
  end

  def logout
    reset_session
    redirect_to auth_login_path
  end

  private

  # Use strong parameters to ensure we're only permitting the username and password for mass assignment
  def user_params
    params.permit(:username, :password)
  end

  # Sets the user if one exists with the given username and password
  def set_user
    @user = User.find_by(username: params[:username])&.authenticate(params[:password])
  end
end
