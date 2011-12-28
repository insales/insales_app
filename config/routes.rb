InsalesApp::Application.routes.draw do
  root :to => 'main#index'

  resource  :session do
    collection do
      get :autologin
    end
  end

  match '/install',   :to => 'insales_app#install',   :as => :install
  match '/uninstall', :to => 'insales_app#uninstall', :as => :uninstall
  match '/login',     :to => 'sessions#new',          :as => :login
  match '/main',      :to => 'main#index',            :as => :main

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
