Rails.application.routes.draw do
  resources :carts
  get '/events/subregion_options' => 'events#subregion_options'
  # get 'interests/index'

  get 'order_items/create'

  get 'order_items/update'

  get 'order_items/destroy'

  get 'carts/show'

  get 'tickets/index'
  get '/users/tickets_history', to: "users#tickets_history", as: :tickets_history
  get '/users/ticket_show', to: "users#ticket_show", as: :ticket_show  
  get 'auth/:provider/callback', to: "users#omniauth" 
  put '/orders', to: 'orders#update'
  get '/location_update', to: 'events#location_update'
  get '/users/reports', to: 'users#reports'
  get '/users/tabs', to: 'users#tabs'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :registrations => :registrations }
  root 'welcome#home'
  #get 'about', to: 'welcome#about'
  resource :subscriptions do
    collection do
      get 'subscription_create'
    end  
  end
  resources :payments
  resources :events do
    member do
      post 'like'
      get :add_wishlist
    end
    collection do
      get 'tabs'
    end
    resources :interests    
    resources :tickets, only: [:index]
  end
  # post '/not_interested/:event_id', to: "interests#not_interested" , as: :not_interested_path

  resources :checkouts, only: [:create]
  resources :users, except: [:new]
  resources :categories, only: [:new, :create, :show]
  resources :relationships, :only => [:create]
  post 'unfollow' => 'relationships#unfollow', as: :unfollow
  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]
  resources :notifications do
    collection do
      post :mark_as_read  
    end
  end
  # Accept and Regect path
  post 'accept/:id', to: 'notifications#accept', as: :notification_accept
  post 'reject/:id', to: 'notifications#reject', as: :notification_reject
  post '/update_notification', to: 'notifications#update_notification', as: :update_notification
  post '/update_message_notification', to: 'notifications#update_message_notification', as: :update_message_notification
  post '/events/:id/contact_email', to: 'events#contact_email', as: 'event_contact_email'
  post "/hook" => "order_items#hook"
  get "/ticket_download", to: "users#ticket_download", as: :ticket_download
  

end
