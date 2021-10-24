class ArticlesController < ApplicationController
  before_action :need_owner_access, only: []
  before_action :need_admin_access, only: [
    :confirm_delete_article,
    :submit_delete_article,
    :remove_comment,
  ]

  def index
    @articles = Article.where(published: true, draft: false).order("CREATED_AT DESC")
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    @setting = Setting.first
    @comment = Comment.new
    @comments = @article.comments.order("created_at DESC").all
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

  def new_comment
    @article = Article.find_by(slug: params.require(:comment).permit(:slug)[:slug])
    if @article.present?
      unless actions_that_have_recaptcha("new_comment_errors")
        redirect_to '/articles/show/' + @article.slug
      else
        if Setting.first.present? && Setting.first.can_comment || session[:user][:is_owner] || session[:user][:is_admin]
            @comment = Comment.new(new_comment_params)
            @comment.user_id = session[:user][:id]
            @comment.article_id = @article.id
            if @comment.save
              flash[:new_comment_success] = "نظر شما با موفقیت ثبت شد."
              redirect_to '/articles/show/' + @article.slug + '/#' + @comment.hash_id
            else
              flash[:new_comment_errors] = @comment.errors.full_messages
              redirect_to '/articles/show/' + @article.slug
            end
        else
          redirect_to '/503'
        end
      end
    else
      redirect_to '/404'
    end
  end

  def remove_comment
    @comment = Comment.find_by(hash_id: params[:hash_id])
    if @comment.present?
      if @comment.user_id == session[:user][:id] || @comment.user.is_owner || @comment.user.is_admin
        @comment.delete
        flash[:comment_removed_successfully] = true
        redirect_to '/articles/show/' + @comment.article.slug
      else
        redirect_to '/503'
      end
    else
      redirect_to '/404'
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
        art.likes.destroy_all
        art.comments.destroy_all
        art.image.destroy
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

  def actions_that_have_recaptcha(flash_name)
    gr_response = params["g-recaptcha-response"]
    if gr_response != nil && gr_response.strip != ""
      gr = Grecaptcha.new
      api_result = gr.verify_recaptcha(gr_response, request.remote_ip)
      if api_result == false
        flash[flash_name] = ["ریکپچا را تایید کنید."]
        return false
      else
        return true
      end
    else
      flash[flash_name] = ["ریکپچا را تایید کنید."]
      return false
    end
	end

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

  def new_comment_params
    params.require(:comment).permit(:content)
  end
end
