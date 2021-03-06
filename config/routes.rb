Rails.application.routes.draw do
  root 'introduction#index'

  # Search
  get 'search/q'
  get 'search/submit_q', to: 'search#q'
  get 'search/q/:search_q', to: 'search#submit_q'
  get 'search/submit_q/:search_q', to: 'search#submit_q'
  post 'search/submit_q'

  # Introduction
  get 'introduction/index'
  get 'about_us', to: 'introduction#about_us'

  # Edit Profile & Manage Users
  get 'dashboard/edit_profile'
  post 'dashboard/submit_edit_profile'
  get 'dashboard/manage_users'
  get 'dashboard/user_profile'
  post 'dashboard/submit_user_profile'

  # Change Password
  get 'dashboard/change_password'
  post 'dashboard/submit_change_password'

  # Article Actions
  get 'dashboard/new_article'
  post 'dashboard/submit_new_article'
  get 'dashboard/submit_new_article', to: 'dashboard#new_article'
  get 'dashboard/my_articles'
  get 'dashboard/edit_article/:slug', to: 'dashboard#edit_article'
  post 'dashboard/submit_edit_article'
  get 'dashboard/articles_that_not_verified'
  post 'dashboard/submit_articles_that_not_verified'
  post 'articles/new_comment'
  post 'articles/remove_comment'
  post 'articles/edit_comment'
  get 'articles/index'
  get 'articles/show/:slug', to: 'articles#show'
  get 'articles/confirm_delete_article/:slug', to: 'articles#confirm_delete_article'
  post 'articles/submit_delete_article'
  
  # Likes
  post 'likes/article/toggle_like', to: 'likes#article_toggle_like'
  post 'likes/course/toggle_like', to: 'likes#course_toggle_like'
  
  # Site Settings
  get 'dashboard/general_statistics'
  get 'dashboard/site_settings'
  post 'dashboard/submit_site_settings'
  
  # Courses
  get 'dashboard/new_course'
  post 'dashboard/submit_new_course'
  get 'dashboard/submit_new_course', to: 'dashboard#new_course'
  get 'dashboard/courses_that_not_verified'
  post 'dashboard/submit_courses_that_not_verified'
  get 'dashboard/my_courses'
  get 'courses/index'
  get 'courses/show/:slug', to: 'courses#show'
  post 'courses/join_at_course'
  get 'courses/videos/show/:slug', to: 'course_episodes#show'
  get 'courses/videos/:slug', to: 'course_episodes#index'
  get 'courses/videos/new_episode/:slug', to: 'course_episodes#new_episode'
  post 'courses/videos/submit_new_episode', to: 'course_episodes#submit_new_episode'
  get 'courses/confirm_delete_course/:slug', to: 'courses#confirm_delete_course'
  post 'courses/submit_delete_course'
  get 'courses/episode_created', to: 'course_episodes#episode_created'

  # Users 
  get 'users/signin'
  post 'users/submit_signup'
  get 'users/signup'
  post 'users/submit_signin'
  get 'users/logout'
  get 'users/confirm_account/:token', to: 'users#confirm_account'
  get 'users/forgot_password'
  post 'users/submit_forgot_password'
  get 'users/forgot_password_set_new/:token', to: 'users#forgot_password_set_new'
  post 'users/submit_forgot_password_set_new/:token', to: 'users#submit_forgot_password_set_new'
  get 'users/terms_and_conditions'
  get 'users/signup_with_github/:clientid', to: 'users#signup_with_github'
  get 'users/signup_with_github_callback'
end
