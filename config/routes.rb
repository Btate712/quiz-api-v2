Rails.application.routes.draw do
  resources :users, :projects, :user_projects, :topics, :questions, :comments
  post '/login', to: 'auth#create'
  get '/profile', to: 'users#profile'
end
