# app/controllers/concerns/auth/registrable.rb
module Auth::Registrable
  extend ActiveSupport::Concern

  included do
    skip_forgery_protection
    before_action :set_user, only: [:login]
  end

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

  private

  def user_params
    params.permit(:username, :password)
  end
end
