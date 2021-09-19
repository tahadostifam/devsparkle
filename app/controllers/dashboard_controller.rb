class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :require_login
  before_action :need_owner_access, only: [
    :manage_users
  ]
  before_action :need_admin_access, only: [
    
  ]

  def edit_profile
  end

  def submit_edit_profile
    @user = User.find_by(id: session[:user]['id'])
    if @user.update(edit_profile_params)
      flash[:edit_profile_success] = 'اطلاعات کاربری شما با موفقیت تغییر کرد.'
      session[:user] = @user
      redirect_to action: :edit_profile
    else
      flash[:edit_profile_errors] = @user.errors.values
      redirect_to action: :edit_profile
    end
  end

  def manage_users
    @users = User.last(20)
  end

  def new_post
  end

  def submit_new_post

  end

  def change_password
  end

  def submit_change_password
    @user = User.find_by(id: session[:user]['id'])
    if @user.authenticate(params.permit(:old_password))
      if @user.update(change_password_params)
        flash[:change_password_success] = "گذرواژه شما با موفقیت تغییر کرد."
        redirect_to action: :change_password_page
        else
        flash[:change_password_errors] = @user.errors.full_messages  
        redirect_to action: :change_password_page
      end
    else
      flash[:change_password_errors] = [
        "گذرواژه فعلی شما صحیح نمی باشد."
      ]
      redirect_to action: :change_password_page
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

  def need_owner_access
    unless session[:user].is_owner?
      redirect_to action: :edit_profile
    end
  end

  def need_admin_access
    unless session[:user].is_admin?
      redirect_to action: :edit_profile
    end
  end

  def edit_profile_params
    params.require(:user).permit(:full_name, :bio, :gender, :website)
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirm)
  end
end
