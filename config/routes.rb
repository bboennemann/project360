Rails.application.routes.draw do
  
  get 'project_report/index'

  resources :project_settings

  resources :time_entries
  resources :forecasts
  post '/forecasts/:id/approval' => 'forecasts#approval'
  get '/forecasts/:id/review' => 'forecasts#review'
  get '/forecasts/:id/clone' => 'forecasts#clone', as: :clone_forecast

  devise_for :users
  resources :users
  post 'users/admin_create' => 'users#create'

  resources :user_forecasts
  post 'user_forecasts/update_time_entry' => 'user_forecasts#update_time_entry'

  resources :organizations do
      resources :project_settings
      resources :departments, only: [:new]
      resources :roles, only: [:new]
  end

  resources :departments do
    resources :project_settings
    resources :users, only: [:new]
  end
  
  resources :clients do
    resources :project_settings
    get 'client_reports/index'
    resources :projects, only: [:new]
  end

  post '/project_roles/new' => 'project_roles#new'
  resources :project_roles


  resources :roles

  resources :projects do
    resources :project_settings
    get 'project_reports/index'
    resources :project_roles, only: [:new]
    get 'project_roles/assign' => 'project_roles#assign'
    resources :forecasts, only: [:new]
  end

  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'organizations#index'

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
