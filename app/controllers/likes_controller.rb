class LikesController < ApplicationController
    def article_toggle_like
        slug = params[:slug]
        uid = session[:user][:id]
        art = Article.find_by(slug: slug)
        if art.present?
            if art.liked(uid)
                art.unlike(art.id, uid)
                redirect_to controller: :articles, action: :show, slug: slug
            else
                art.like(art.id, uid)
                redirect_to controller: :articles, action: :show, slug: slug
            end
        else
            redirect_to controller: :articles, action: :show, slug: slug
        end
    end
end
