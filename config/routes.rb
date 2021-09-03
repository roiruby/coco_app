Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'register', to: 'sessions#register'
  get 'reset', to: 'password_resets#reset'
  
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
  
  get 'users/:id/evaluation', to: 'users#evaluation',  as: :evaluation
  
  get 'users/:id/posts', to: 'users#posts',  as: :user_posts
  
  get 'posts/new_arrival', to: 'posts#new_arrival',  as: :new_arrival
  get 'posts/deadline_approaching', to: 'posts#deadline_approaching',  as: :deadline_approaching
  
  get 'posts/:id/cancel', to: 'posts#cancel',  as: :cancel
  
  get  'contact' =>'contacts#index'
  post 'contact/confirm' => 'contacts#confirm'
  post 'contact/done' => 'contacts#done'
  
  get 'tos', to: 'toppages#tos', as: :tos
  get 'privacy', to: 'toppages#privacy', as: :privacy
  get 'faq', to: 'toppages#faq', as: :faq
  get 'topic', to: 'toppages#topic', as: :topic
  
  get  'quit' =>'quits#new'
  post  'quit' =>'quits#create'
  get  'quits' =>'quits#index'

  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :user_reports, only: [:create]
    
    member do
      get :followings
      get :followers
      get :favorites
      get :entries
      get :participateds
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
  
  resources :evaluations, only: [:create]
  resources :destinations, only: [:create]
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :informations, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :newsletters, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :entries, only: [:create, :destroy] do
    patch :toggle_status
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end
