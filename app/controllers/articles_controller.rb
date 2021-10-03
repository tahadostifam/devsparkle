class ArticlesController < ApplicationController
  before_action :need_owner_access, only: [
    
  ]
  before_action :need_admin_access, only: [
    :confirm_delete_article,
    :submit_delete_article
  ]

  def index
    @articles = Article.where(published: true, draft: false)
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    if session[:user] != nil
      if session[:user][:id] == @article.user_id || session[:user][:is_owner]
        render :show, :locals => { :show_actions => true }
      else
        render :show, :locals => { :show_actions => false }
      end
    else
      render :show, :locals => { :show_actions => false }
    end
  end

  def confirm_delete_article
    @article = Article.find_by(slug: params[:slug])
    unless @article.present?
      redirect_to action: :index
    end
  end

  def submit_delete_article
    slug = params[:slug]
    art = Article.find_by(slug: slug)
    if art.present?
      if session[:user][:is_owner]
        art.destroy
        redirect_to :index
      elsif art.user_id == session[:user][:id]
        art.destroy
        redirect_to :index
      else
        redirect_to :index
      end
    else
      redirect_to :index
    end
  end

  private

  def need_owner_access
    unless session[:user].is_owner?
      redirect_to '/503'
    end
  end

  def need_admin_access
    unless session[:user].is_admin?
      redirect_to '/503'
    end
  end
end
