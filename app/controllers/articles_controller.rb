class ArticlesController < ApplicationController
  before_action :need_owner_access, only: [
    
  ]
  before_action :need_admin_access, only: [
    :confirm_delete_article
  ]

  def index
    @articles = Article.where(published: true, draft: false)
  end

  def show
    @article = Article.find_by(slug: params[:slug])
  end

  def confirm_delete_article
    @article = Article.find_by(slug: params[:slug])
    unless @article.present?
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
