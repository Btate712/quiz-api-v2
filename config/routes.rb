Rails.application.routes.draw do
  resources :users, :projects, :user_projects, :topics, :questions, :comments
end
