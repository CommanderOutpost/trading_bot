# app/controllers/concerns/auth/password_manageable.rb
module Auth::PasswordManageable
  extend ActiveSupport::Concern

  included do
    before_action :set_user_by_session, only: [:change_password]
  end

  def change_password
    return unless request.post?
    if @user.authenticate(params[:current_password])
      if params[:new_password] == params[:current_password]
        flash.now[:error] = "New password must be different from current password"
        render :change_password
      else
        if @user.update(password: params[:new_password])
          redirect_to root_path, notice: "Password successfully updated"
        else
          flash.now[:error] = "Error updating password"
          render :change_password
        end
      end
    else
      flash.now[:error] = "Current password is incorrect"
      render :change_password
    end
  end

  private

  def set_user_by_session
    @user = User.find(session[:user_id])
  end
end
