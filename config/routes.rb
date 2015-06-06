Rails.application.routes.draw do
  root to: 'pages#home'
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'pages#home'
  get '/about_us', to: 'pages#about_us'
  get '/privacy_policy', to: 'pages#privacy_policy'
  get '/delivery_information', to: 'pages#delivery_information'
  get 'terms_and_conditions', to: 'pages#terms_and_conditions'
  get '/my_account', to: 'pages#my_account'
  get '/my_orders', to: 'pages#my_orders'

  get '/contact_us', to: 'contact_us#new'
  post '/contact_us', to: 'contact_us#create'

  resources :products , only: [:show] do
    collection do
      get '/search' , to: 'products#search'
    end
  end

  resources :categories, only: [:show]
  resources :sacred_symbols, only: [:show]

  namespace :admin do
    resources :products, only: [:index, :create, :edit, :update, :destroy]
    resources :categories, only: [:index, :create, :edit, :update, :destroy, :show]
    resources :sacred_symbols , only: [:index, :create, :edit, :update, :destroy]
    resources :orders, only: [:index, :edit, :update]
    resources :users, only: [:index, :update] do
      member do
        get '/orders', to: 'users#orders'
      end
    end
    get '/stock', to: 'products#stock'
    resources :products do
      member do
        patch '/stock', to: 'products#update_stock'
      end
    end
  end

  get '/sign_up', to: 'users#new'
  post '/sign_up', to: 'users#create'
  resources :users, only: [:update]

  get '/login', to: 'sessions#new'  
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/shopping_bag', to: 'user_shopping_bag_items#index'
  get '/wishlist', to: 'user_wishlist_items#index'

  resources :user_shopping_bag_items ,only: [:create, :update, :destroy]
  resources :user_wishlist_items ,only: [:create, :destroy]

  get '/checkout', to: 'orders#new'
  post '/checkout', to: 'orders#create'
  resources :orders, only: [:show] do
    collection do
      get '/terms_and_conditions', to: 'orders#terms_and_conditions'
    end
  end  
  get '/payment', to: 'orders#payment_new'
  post '/payment', to: 'orders#payment_create'

  get '/subregion_options' => 'orders#subregion_options'

  post "/orders/:slug" => "orders#payment_show"
  post "/paypal_hook" => "orders#paypal_hook"

end
