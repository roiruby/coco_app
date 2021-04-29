Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'mypage', to: 'mypage#index', as: :mypage
  
  get 'categories/:id', to: 'categories#show', as: :category
  
  get 'prefectures/:id', to: 'prefectures#show', as: :prefecture
  get 'cities/:id', to: 'cities#show', as: :city
  get 'spots/:id', to: 'spots#show', as: :spot
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
    
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  resources :posts, only: [:create, :edit, :update, :destroy, :index, :show, :new]
  
  resources :destinations, only: [:create]
  resources :relationships, only: [:create, :destroy]
  

end
