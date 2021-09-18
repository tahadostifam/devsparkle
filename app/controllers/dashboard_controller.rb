class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :require_login

  def index
  end

  def edit_profile
    @user = User.find_by(id: session[:user]['id'])
    if @user.update(edit_profile_params)
      flash[:edit_profile_success] = 'اطلاعات کاربری شما با موفقیت تغییر کرد.'
      session[:user] = @user
      redirect_to action: :index
    else
      flash[:edit_profile_errors] = @user.errors.full_messages
    end
  end

  def change_password
    @user = User.find_by(id: session[:user]['id'])
    if @user.authenticate(params.permit(:old_password))
      if @user.update(change_password_params)
        flash[:change_password_success] = "گذرواژه شما با موفقیت تغییر کرد."
        else
        flash[:change_password_errors] = @user.errors.full_messages  
      end
    else
      flash[:change_password_errors] = [
        "گذرواژه فعلی شما صحیح نمی باشد."
      ]
    end
  end

  private

  def require_login
    unless session[:user].present?
      redirect_to '/users/signin'
    else
      @user = User.find_by(id: session[:user]['id'])
    end
  end

  def edit_profile_params
    params.require(:user).permit(:full_name)
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirm)
  end
end
