Rails.application.routes.draw do
  root 'introduction#index'
  
  get 'introduction/index'
  get 'introduction/about_us'

  get 'dashboard/index'
  get 'users/signin'
  get 'users/signup'
  get 'users/forgot_password'
  get 'users/terms_and_conditions'
  get 'articles/index'
  get 'articles/show'
  get 'articles/new'
  get 'articles/edir'
  get 'articles/destroy'
  # get 'courses/index'
  # get 'courses/show'
  # get 'courses/edit'
  # get 'courses/new'
  # get 'courses/delete'
end
