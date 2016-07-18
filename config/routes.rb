Rails.application.routes.draw do
  get '/events/subregion_options' => 'events#subregion_options'
  get 'interests/index'

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
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users  
  root 'welcome#home'
  #get 'about', to: 'welcome#about'
  
  resources :events do
    member do
      post 'like'
      get :add_wishlist
    end
    collection do
      get 'tabs'
    end
    resources :interests, :only => [:index, :create]    
    resources :tickets, only: [:index]

    #resources :reviews, except: [:index, :show]   
  end
  post '/not_interested/:event_id', to: "interests#not_interested" , as: :not_interested_path

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
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
