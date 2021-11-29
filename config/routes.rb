Rails.application.routes.draw do
  devise_for :users
  resources :appointments
  resources :professionals
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "public#home"
end
