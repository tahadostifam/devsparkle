 class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :require_login
  before_action :need_owner_access, only: [
    :manage_users,
    :user_profile,
    :submit_user_profile,
    :articles_that_not_verified,
    :submit_articles_that_not_verified
  ]
  before_action :need_admin_access, only: [
    :new_article,
    :submit_new_article,
    :my_articles,
    :general_statistics
  ]

  def site_settings
    @setting = Setting.first
    unless @setting.present?
      @setting = Setting.new
    end
  end

  def articles_that_not_verified
    @atnv = Article.where(published: false, draft: false)
  end

  def submit_articles_that_not_verified
    @atnv = Article.where(slug: params[:slug])
    if @atnv.present?
      if @atnv.update(published: true)
        redirect_to params[:next_page]
      else
        redirect_to '/503'
      end
    else
      redirect_to action: :articles_that_not_verified
    end
  end

  def submit_site_settings
    @setting = Setting.first
    if @setting.present?
      if @setting.update(site_settings_params)
        flash[:site_settings_success] = "تنظیمات وبسایت با موفقیت تغییر کرد."
        redirect_to action: :site_settings
      else
        flash[:site_settings_errors] = @setting.errors.full_messages
        redirect_to action: :site_settings
      end
    else
      @setting = Setting.new(site_settings_params)
      if @setting.save
        flash[:site_settings_success] = "تنظیمات وبسایت با موفقیت تغییر کرد."
        redirect_to action: :site_settings
      else
        flash[:site_settings_errors] = @setting.errors.full_messages
        redirect_to action: :site_settings
      end
    end
  end

  def submit_edit_profile
    @user = User.find_by(id: session[:user]['id'])
    if @user.update(edit_profile_params)
      flash[:edit_profile_success] = 'اطلاعات کاربری شما با موفقیت تغییر کرد.'
      session[:user] = @user
      redirect_to action: :edit_profile
    else
      flash[:edit_profile_errors] = @user.errors.full_messages
      redirect_to action: :edit_profile
    end
  end

  def manage_users
    @last_users = User.last(20)
    @admins_list = User.where(is_admin: true)
  end

  def user_profile
    user_id = params['id']
    unless user_id == session[:user]['id'].to_s
      @up = User.find_by(id: user_id)
    end
  end

  def submit_user_profile
    @up = User.find_by(username: params[:user][:username])
    if params[:user][:username] == session[:user][:username]
      return redirect_to :manage_users  
    end

    if @up.present?
      if @up.update(update_user_profile_params)
        flash[:user_profile_success] = 'اطلاعات کاربری کاربر با موفقیت تغییر کرد.'
        redirect_to action: 'user_profile', :id => @up.id
      else
        flash[:user_profile_errors] = @up.errors.full_messages
        redirect_to action: 'user_profile', :id => @up.id
      end
    else
      redirect_to action: 'user_profile', :id => @up.id
    end
  end

  def my_articles
    @my_articles = Article.where(user_id: session[:user]['id'])
  end

  def new_article
    @article = Article.new
  end

  def submit_new_article
    unless actions_that_have_recaptcha("new_article_errors")
      @article = Article.new(new_article_params)
      render '/dashboard/new_article/'
    else
      @article = Article.new(new_article_params)
      @article.user_id = session[:user]['id']
      unless session[:user][:is_owner]
        @article.published = false
      end
      if @article.save 
        render 'articles/article_created', :locals => {published: @article.published, slug: @article.slug}
      else
        flash[:new_article_errors] = @article.errors.full_messages
        render :new_article
      end
    end
  end

  def edit_article
    @article = Article.find_by(slug: params[:slug])
    unless @article.present?
      redirect_to '/404'
    end
  end

  def submit_edit_article
    @article = Article.find_by(slug: params[:slug])
    if @article.present?
      unless session[:user][:is_owner]
        @article.published = false
        params[:published] = false
      end
      if params[:image] != nil
        @article.image.purge
      end
      if @article.update(new_article_params)
        flash[:edit_article_success] = 'مقاله با موفقیت ویرایش شد.'
        redirect_to '/dashboard/edit_article/' + @article.slug
      else
        flash[:edit_article_errors] = @article.errors.full_messages
        redirect_to '/dashboard/edit_article/' + @article.slug
      end
    else
      redirect_to '/404'
    end
  end

  def submit_change_password
    @user = User.find_by(id: session[:user]['id'])
    if @user.authenticate(params.permit(:old_password)['old_password'])
      if @user.update(change_password_params)
        flash[:change_password_success] = "گذرواژه شما با موفقیت تغییر کرد."
        redirect_to action: :change_password
        else
        flash[:change_password_errors] = @user.errors.full_messages  
        redirect_to action: :change_password
      end
    else
      flash[:change_password_errors] = [
        "گذرواژه فعلی شما صحیح نمی باشد."
      ]
      redirect_to action: :change_password
    end
  end

  def general_statistics
    @articles = Article.all
    @users = User.all
    @likes = Like.all
    @comments = Comment.all
  end

  private

  def actions_that_have_recaptcha(flash_name)
    gr_response = params["g-recaptcha-response"]
    if gr_response != nil && gr_response.strip != ""
      gr = Grecaptcha.new
      api_result = gr.verify_recaptcha(gr_response, request.remote_ip)
      if api_result == false
        flash[flash_name] = ["ریکپچا را تایید کنید."]
        return false
      else
        return true
      end
    else
      flash[flash_name] = ["ریکپچا را تایید کنید."]
      return false
    end
	end

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

  def new_article_params
    params.require(:article).permit(:header, :cover_text, :image, :content, :draft, :published)
  end

  def new_article_params
    params.require(:article).permit(:slug, :header, :cover_text, :image, :content, :draft, :published)
  end

  def site_settings_params
    params.require(:setting).permit(:about_us, :can_comment, :tac)
  end

  def update_user_profile_params
    params.require(:user).permit(:is_admin, :is_banned, :bio, :website)
  end

  def edit_profile_params
    params.require(:user).permit(:full_name, :bio, :gender, :website)
  end

  def change_password_params
    params.permit(:password, :password_confirmation)
  end
end
