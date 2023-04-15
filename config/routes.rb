Rails.application.routes.draw do
  resources :companies
  resources :cranes
  
  root 'home#index'

  get 'password', to: 'passwords#edit', as: :edit_password
  patch 'password', to: 'passwords#update'
  
  get 'sign_up', to: 'registrations#new'

  get 'user_sign_up', to: 'registrations#new_user'
  post 'user_sign_up', to: 'registrations#create_user'

  get 'company_sign_up', to: 'registrations#new_company'
  post 'company_sign_up', to: 'registrations#create_company'

  get 'company_check_contractors', to: 'companies#view_contractors'
  post 'company_check_contractors', to: 'companies#add_contractors'
  get 'edit_contractors', to: 'companies#edit_contractors'
  delete 'destroy_contractors', to: 'companies#destroy_contractor'
  get 'company_check_contractor_cranes', to: 'companies#view_contractor_cranes'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy'

  get 'password/reset', to: 'password_resets#new'
  post 'password/reset', to: 'password_resets#create'
  get 'password/reset/edit', to: 'password_resets#edit'
  patch 'password/reset/edit', to: 'password_resets#update'

  get 'compose_user', to: 'composes#new_user_email'
  post 'compose_user', to: 'composes#create_user_email'
  get 'compose_company', to: 'composes#new_company_email'
  post 'compose_company', to: 'composes#create_company_email'

  get 'home/about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
