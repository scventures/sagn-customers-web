Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords',
    registrations: 'customers/registrations',
    confirmations: 'customers/confirmations'
  }

  resource :profile, only: [:show, :edit, :update] do
    get :resend_email_confirmation
    get :resend_phone_confirmation
    patch :confirm_phone
  end
  
  resources :venues, only: :index
  resources :locations
  resources :staff, only: [:new, :create, :index, :destroy] do
    patch :create_multiple, on: :collection
  end
  resources :contractors, except: [:edit, :update, :show] do
    patch :create_multiple, on: :collection
  end

  resource :dashboard, only: :show
  resources :service_requests, only: [:new, :create, :show]
  
  resources :location, module: 'location', only: [] do
    resources :equipment_items, only: [:index]
  end
  
  authenticated :customer do
    root 'dashboards#show', as: :authenticated_root
  end

  root :to => 'high_voltage/pages#show', id: 'home'

end
