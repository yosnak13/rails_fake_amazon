Rails.application.routes.draw do
  get 'users/edit'
  get 'users/update'
  get 'users/mypage'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations',
    :unlocks => 'users/unlocks',
  }

  devise_scope :user do
    root :to => "users/sessions#new"
    get 'singup', :to => 'users/registrations#new'
    get "verify", :to => "users/registrations#verify"
    get 'login', :to => 'users/sessions#new'
    get 'logout', :to => 'users/sessions#destroy'
  end

  resources :products do
    member do
      # post :favorite
      get :favorite
    end

    resources :reviews, only: [:create]
  end
end
