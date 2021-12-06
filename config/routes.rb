Rails.application.routes.draw do
  
  get 'exports', to: 'exports#new', as: 'exports'
  post 'exports', to: 'exports#create', as: 'export_pdf' 

  scope "/accounts" do
    resources :users
  end
  devise_for :users

  resources :professionals do 
    resources :appointments do 
      collection do
       delete 'cancel', to: 'appointments#cancel', as: 'cancel' 
      end
    end
  end 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "public#home"
end
