class IntroductionController < ApplicationController
    def index
        @popular_articles = 
            Article.left_joins(:likes).group(:article_id).order("COUNT(likes.article_id) DESC").limit(20)
    end

    def about_us
        @setting = Setting.first
    end
end
