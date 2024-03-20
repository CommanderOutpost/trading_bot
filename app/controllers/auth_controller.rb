class AuthController < ApplicationController
  skip_forgery_protection

  def register
    if request.post?
      username = params[:username]
      password = params[:password]
      puts username, password

      if User.exists?(username: username)
        flash[:error] = "Username already exists"
        redirect_to :action => "login"
        return
      else
        @user = User.new(username: username, password: password)
        if @user.save!
          redirect_to :action => "login"
        else
          flash[:error] = "There was a problem registering"
        end
      end
    end
  end

  def login
    if request.post?
      username = params[:username]
      password = params[:password]
      @user = User.find_by(username: username)&.authenticate(password)
      if @user
        session[:user_id] = @user.id
        redirect_to root_path
      else
        flash[:error] = "Invalid username or password"
        redirect_to :action => "login"
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :action => "login"
  end
end
