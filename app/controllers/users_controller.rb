class UsersController < ApplicationController
  def submit_signup
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user: @user).send_confirm_account.deliver_later

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

  def signup
    github_api = GithubApi.new

    @user = User.new
    
    render :signup, :locals => { :github_clientid => github_api.clientid }
  end
  
  def signup_with_github
    redirect_to 'https://github.com/login/oauth/authorize?client_id=' + params[:clientid]
  end

  def signup_with_github_callback
    github_api = GithubApi.new

    user_info = github_api.fetch_github params['code']

    if user_info.present?
      unless user_info['email'].present?
        return render :complete_signup_with_github, :locals => { nil_email: true }
      end
      @user = User.new
      @user.email = user_info['email']
      @user.full_name = user_info['name']
      @user.username = user_info['login']
      flash[:user_info_in_signup_with_github] = @user
      render :complete_signup_with_github, :locals => { nil_email: false }
    else
      redirect_to action: :signup
    end
  end

  def complete_signup_with_github
    @user = User.new(flash[:user_info_in_signup_with_github])
    @user.password = complete_signup_with_github_params['password']
    @user.password_confirmation = complete_signup_with_github_params['password_confirmation']
    @user.accept_terms_and_conditions = complete_signup_with_github_params['accept_terms_and_conditions']
    if @user.save
      session[:user] = @user
      redirect_to '/dashboard/index'
    else
      flash[:complete_signup_with_github_errors] = @user.errors.full_messages
      render :complete_signup_with_github, :locals => { nil_email: false, user: @user }
    end
  end

  def signin
    @user = User.new
  end

  def submit_signin
    @user = User.find_by(username: signin_params['username'])
    if @user.present? && @user.authenticate(signin_params['password'])
      if @user.email_confirmed?
        session[:user] = @user
        redirect_to root_path
      else
        flash[:signin_errors_list] = [
          "ایمیل شما تایید نشده است... ورود به اکانت امکان پذیر نمی باشد."
        ]
        redirect_to action: 'signin'
      end
    else
      flash[:signin_errors_list] = [
        "نام کاربری یا گذرواژه شما صحیح نمی باشد"
      ]
      redirect_to action: 'signin'
    end
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end

  def forgot_password
  end

  def terms_and_conditions
    @setting = Setting.first
  end

  private

  def complete_signup_with_github_params
    params.require(:user).permit(:password, :password_confirmation, :accept_terms_and_conditions)
  end

  def signin_params
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.permit(:full_name, :email, :username, :password, :password_confirmation, :accept_terms_and_conditions)
  end
end
