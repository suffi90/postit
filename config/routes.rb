PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
    resources :categories, only: [:show]
  end
  resources :categories, only: [:new, :create]
end
