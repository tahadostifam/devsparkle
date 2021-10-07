class ArticlesController < ApplicationController
  before_action :need_owner_access, only: []
  before_action :need_admin_access, only: [
    :confirm_delete_article,
    :submit_delete_article
  ]

  def index
    @articles = Article.where(published: true, draft: false)
  end

  def show
    @article = Article.find_by(slug: params[:slug])

    if @article.present?
      if session[:user] != nil
        if @article.user_id == session[:user][:id] || session[:user][:is_owner]
          return render :show, :locals => { :show_actions => true }
        end
      end

      if (@article.published? == false || @article.draft? == true)
        @article = nil
      end

      render :show, :locals => { :show_actions => false }
    end
  end

  def confirm_delete_article
    @article = Article.find_by(slug: params[:slug])
    if @article.nil?
      redirect_to action: :index
    end
  end

  def submit_delete_article
    slug = params[:slug]
    art = Article.find_by(slug: slug)
    if art.present?
      if session[:user].present? && session[:user][:is_owner] || art.user_id == session[:user][:id]
        art.destroy
        render 'article_deleted'
      else
        redirect_to '/503'
      end
    else
      redirect_to action: :index
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
