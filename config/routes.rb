InsalesApp::Application.routes.draw do
  root to: 'main#index'

  resource :session do
    collection do
      get :autologin
    end
  end

  resources :products, only: [:show, :update]

  get '/install',   to: 'insales_app#install',   as: :install
  get '/uninstall', to: 'insales_app#uninstall', as: :uninstall
  get '/login',     to: 'sessions#new',          as: :login
  get '/main',      to: 'main#index',            as: :main
  get '/products',  to: 'products#index',        as: :products
  get '/update_products_data', to: 'products_data#update', as: :update_products_data
  get '/create_product_widget', to: 'product_widgets#create', as: :create_product_widget

  get ':controller/:action/:id'
  get ':controller/:action/:id.:format'

  namespace :api do
    namespace :v1 do
      resources :insales_products, only: [:show]
    end
  end
end
