class SearchController < ApplicationController
  def q
  end

  def submit_q
    @search_in_articles = Article.where('header LIKE ?', "%#{params['search_q']}%")
    @search_in_courses = Course.where('header LIKE ?', "%#{params['search_q']}%")
    render 'search/q'
  end
end
