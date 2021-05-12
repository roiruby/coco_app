Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'mypage', to: 'mypage#index', as: :mypage
  
  get 'categories/:id', to: 'categories#show', as: :category
  
  get 'users/:id/account_edit', to: 'users#account_edit',  as: :account_edit
  patch 'users/:id/account_edit', to: 'users#account_update'
  
  get 'keywords', to: 'keywords#index', as: :keyword
  
  get 'posts/:id/comment', to: 'posts#comment',  as: :comment
  
  get 'search', to: 'posts#search', as: :search

  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
    
    member do
      get :followings
      get :followers
      get :favorites
    end
  end
  
  resources :posts, only: [:create, :edit, :update, :destroy, :index, :show, :new] do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'confirm'
    end       
  end
  
  resources :destinations, only: [:create]
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :favorites, only: [:create, :destroy]
  

end
