class SearchController < ApplicationController
  def q
  end

  def submit_q
    # @search_result = ActiveRecord::Base.connection.execute("""
    #   SELECT * FROM articles 
    #     WHERE header LIKE '%#{params['search_q']}%'
    #   union all
    #   SELECT * FROM courses 
    #     WHERE header LIKE '%#{params['search_q']}%'
    # """).to_a
    @search_result = Course.where("header LIKE '%#{params['search_q']}%'") 
                    .union(Article.where("header LIKE '%#{params['search_q']}%'"))
    render 'search/q'
  end
end
