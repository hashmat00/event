Rails.application.routes.draw do
  get 'interests/index'

  get 'order_items/create'

  get 'order_items/update'

  get 'order_items/destroy'

  get 'carts/show'

  get 'tickets/index'

  get 'auth/:provider/callback', to: "users#omniauth" 

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users  
  root 'welcome#home'
  #get 'about', to: 'welcome#about'
  resources :users do
    resources :favourites, :only => [:index, :create, :destroy]
  end
  resources :events do
    member do
      post 'like'
    end
    resources :tickets, only: [:index]
    #resources :reviews, except: [:index, :show]   
  end
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
