Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'mypage', to: 'mypage#index', as: :mypage
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy]
  
  resources :posts, only: [:create, :edit, :update, :destroy, :index, :show, :new]
  
end
