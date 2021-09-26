class ArticlesController < ApplicationController
  def index
    @articles = Article.where(published: true, draft: false)
  end

  def show
    @article = Article.find_by(slug: params[:slug])
  end
end
