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

    def course_toggle_like
        slug = params[:slug]
        uid = session[:user][:id]
        co = Course.find_by(slug: slug)
        if co.present?
            if co.liked(uid)
                co.unlike(co.id, uid)
                redirect_to controller: :courses, action: :show, slug: slug
            else
                co.like(co.id, uid)
                redirect_to controller: :courses, action: :show, slug: slug
            end
        else
            redirect_to controller: :courses, action: :show, slug: slug
        end
    end
end
