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
  
  get 'posts/:id/entry', to: 'posts#entry',  as: :entry_page
  
  get 'posts/:id/member', to: 'posts#member',  as: :member
  
  get 'search', to: 'posts#search', as: :search
  
  get 'users/:id/report', to: 'users#report',  as: :user_report
  get 'posts/:id/report', to: 'posts#report',  as: :post_report
  
  get 'user_reports', to: 'users#user_reports',  as: :user_reports
  get 'post_reports', to: 'posts#post_reports',  as: :post_reports

  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :user_reports, only: [:create]
    
    member do
      get :followings
      get :followers
      get :favorites
      get :entries
    end
  end
  
  resources :posts, only: [:create, :edit, :update, :destroy, :index, :show, :new] do
    resources :comments, only: [:create, :destroy]
    resources :post_reports, only: [:create]
    resources :members, only: [:create, :destroy]
    collection do
      get 'confirm'
    end       
  end
  
  resources :destinations, only: [:create]
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :informations, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :entries, only: [:create, :destroy] do
    patch :toggle_status
  end
  

end
