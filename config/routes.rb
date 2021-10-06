Rails.application.routes.draw do
  root 'introduction#index'
  
  get 'introduction/index'
  get 'introduction/about_us'

  get 'dashboard/edit_profile'
  post 'dashboard/submit_edit_profile'

  get 'dashboard/manage_users'
  get 'dashboard/user_profile'
  post 'dashboard/submit_user_profile'

  get 'dashboard/change_password'
  post 'dashboard/submit_change_password'

  get 'dashboard/new_article'
  post 'dashboard/submit_new_article'
  get 'dashboard/submit_new_article', to: 'dashboard#new_article'
  get 'dashboard/my_articles'

  get 'users/signin'
  post 'users/submit_signup'
  get 'users/signup'
  post 'users/submit_signin'
  get 'users/logout'
  get 'users/confirm_account/:token', to: 'users#confirm_account'
  get 'users/forgot_password'
  get 'users/terms_and_conditions'

  get 'articles/index'
  get 'articles/show/:slug', to: 'articles#show'
  get 'articles/confirm_delete_article/:slug', to: 'articles#confirm_delete_article'
  post 'articles/submit_delete_article'

  post 'likes/toggle_like'

  # get 'courses/index'
  # get 'courses/show'
  # get 'courses/edit'
  # get 'courses/new'
  # get 'courses/delete'
end
