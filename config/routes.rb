Rails.application.routes.draw do
  
  root to: 'admin/dashboard#index'
 

  devise_for :user, path: 'admin'
  namespace :admin do
    resources :users

    get 'edit_password', to: 'users#edit_password',  as: :edit_password
    patch 'update_password', to: 'users#update_password',  as: :update_password
   root to: 'dashboard#index'
  end 
  
end
