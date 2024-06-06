# app/controllers/concerns/auth/authenticable.rb
module Auth::Authenticable
  extend ActiveSupport::Concern

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

  def set_user
    @user = User.find_by(username: params[:username])&.authenticate(params[:password])
  end
end
