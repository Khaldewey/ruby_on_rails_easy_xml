Rails.application.routes.draw do
  
  root to: 'admin/documents#index'
 

  devise_for :user, path: 'admin', controllers: {
    registrations: 'admin/registrations'
  }
  namespace :admin do
    resources :users
    resources :reports
    get 'edit_password', to: 'users#edit_password',  as: :edit_password
    patch 'update_password', to: 'users#update_password',  as: :update_password
    
    resources :documents, only: [:upload] do
      collection do
        post :upload
      end 
      
    end
   
    root to: 'documents#index' 
  end 

  
  
end
