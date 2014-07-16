Rails.application.routes.draw do

  get 'verify' => 'customers/voter_verify#new', as: :voter_verify
  post 'verify' => 'customers/voter_verify#search', as: :search_voter_verify

  devise_for :users, :skip => [:sessions], :controllers => { :registrations => "users/registrations" }, :path_names => { :signup => "register" }
  as :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get 'dashboard' => 'users/dashboard#show', :as => :users_dashboard
  end

  devise_scope :user do
    get "/signup" => "users/registrations#new", :as => :signup
  end

  namespace :admin do
    devise_scope :user do
      resources :voters do
        collection do
          match 'search' => 'voters#search', via: [:get, :post], as: :search
        end
      end
      resources :users
    end
  end

  get 'admin/dashboard' => 'admin/dashboard#show', :as => :admin_dashboard

  authenticated :user do
    root :to => "users/dashboard#show", :as => "authenticated_user_root"
  end

  root 'dashboard#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
