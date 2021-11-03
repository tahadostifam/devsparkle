class UsersController < ApplicationController
  include Recaptcha
  
  def submit_signup
    unless have_recaptcha("signup_errors_list")
      redirect_to '/users/signup'
    else
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
    # github button
    redirect_to 'https://github.com/login/oauth/authorize?client_id=' + params[:clientid]
  end

  def signup_with_github_callback
    # form

    github_api = GithubApi.new

    user_info = github_api.fetch_github params['code']

    if user_info.present?
      @user = User.new
      unless user_info['email'].present?
        return render :signup_with_github_finished, :locals => { nil_email: true, um_used: false }
      end
      @user.email = user_info['email']
      @user.username = user_info['login']
      check_email_and_username_quniqness = User.where(username: @user.username, email: @user.email).first
      if check_email_and_username_quniqness != nil
        return render :signup_with_github_finished, :locals => { nil_email: false, um_used: true }  
      end
      @user.full_name = user_info['name']
      rdnpss = SecureRandom.alphanumeric(15)
      @user.password = rdnpss
      @user.password_confirmation = rdnpss
      @user.email_confirmed = true

      if @user.save
        session[:user] = @user
        render :signup_with_github_finished, :locals => { nil_email: false, um_used: false }
      else
        redirect_to '/500'
      end
    else
      redirect_to action: :signup
    end
  end

  def signin
    @user = User.new
  end

  def submit_signin
    unless have_recaptcha("signin_errors_list")
      redirect_to '/users/signin'
    else
      @user = User.find_by(username: signin_params['username'])
      if @user.present? && @user.authenticate(signin_params['password'])
        if @user.email_confirmed?
          if @user.is_banned?
            flash[:signin_errors_list] = [
              "اکانت شما بن شده است!"
            ]
            redirect_to action: 'signin'
          else
            session[:user] = @user

            if signin_params[:remember_me] == "1"
              cookies.signed.permanent[:user_id] = {
                value: @user.id,
                expires: 1.weeks.from_now
              }
            else
              cookies.delete :user_id
            end

            redirect_to root_path
          end
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
  end

  def logout
    session[:user] = nil
    cookies.delete :user_id
    redirect_to root_path
  end

  def forgot_password
  end

  def submit_forgot_password
    unless have_recaptcha("forgot_password_errors")
      redirect_to '/users/forgot_password'
    else
      @user = User.find_by(email: params[:email])
      if @user.present?
        if @user.is_banned?
          flash[:forgot_password_errors] = [
            "اکانت شما بن شده است."
          ]
          redirect_to '/users/forgot_password'
        else
          @user.set_forgot_password_token
          UserMailer.with(user: @user).send_forgot_password.deliver_later

          flash[:forgot_password_sended_successfully] = true
          redirect_to '/users/forgot_password'
        end
      else
        flash[:forgot_password_errors] = [
          "کاربری با این ایمیل وجود ندارد."
        ]
        redirect_to '/users/forgot_password'
      end
    end
  end

  def forgot_password_set_new
    @user = User.find_by(forgot_password_token: params[:token])
    if @user.present? && @user.forgot_password_valid_expire?
      render 'users/forgot_password_set_new', locals: { form: true, bad_token: false }
    else
      render 'users/forgot_password_set_new', locals: { form: false, bad_token: true }
    end
  end

  def submit_forgot_password_set_new
    @user = User.find_by(forgot_password_token: params[:token])
    if @user.present? && @user.forgot_password_valid_expire?
      if @user.update(forgot_password_set_new_params)
        @user.clean_forgot_password
        render 'users/forgot_password_set_new_success'
      else
        flash[:forgot_password_set_new_errors] = @user.errors.full_messages
        render 'users/forgot_password_set_new'
      end
    else
      redirect_to action: :forgot_password
    end
  end

  def terms_and_conditions
    @setting = Setting.first
  end

  private

  def forgot_password_set_new_params
    params.permit(:password, :password_confirmation)
  end

  def complete_signup_with_github_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def signin_params
    params.require(:user).permit(:username, :password, :remember_me)
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :username, :password, :password_confirmation, :accept_terms_and_conditions)
  end
end
