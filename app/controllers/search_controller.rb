class SearchController < ApplicationController
  def q
  end

  def submit_q
    @search_result = Course.where("header LIKE '%#{params['search_q']}%'") 
                    .union(Article.where("header LIKE '%#{params['search_q']}%'"))
    render 'search/q'
  end
end
