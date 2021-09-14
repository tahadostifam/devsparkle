class UsersController < ApplicationController
  def signup
  end

  def submit_signup
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user: @user).send_confirm_account.deliver

      flash[:success_signup] = true
      flash[:signup_errors_list] = nil
      redirect_to action: 'signup'
    else
      flash[:success_signup] = false
      flash[:signup_errors_list] = @user.errors.full_messages
      redirect_to action: 'signup'
    end
  end

  def confirm_account
    if params.permit(:token).present?
      user = User.find_by(confirm_token: params[:token])
      if user
        user.email_activate

        flash[:account_confirmed] = true
        render 'users/confirm_account_view'
      else
        render 'users/confirm_account_view'
        flash[:account_confirmed] = false
      end
    end
  end

  def signin
  end

  def forgot_password
  end

  def terms_and_conditions
  end

  private

  def user_params
    params.permit(:full_name, :email, :username, :password, :password_confirmation)
  end
end
