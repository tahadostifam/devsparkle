class IntroductionController < ApplicationController
    def index
        @popular_articles = 
            Article.left_joins(:article_likes).group(:article_id).order("COUNT(article_likes.article_id) DESC").limit(20)
    end

    def about_us
        @setting = Setting.first
    end
end
