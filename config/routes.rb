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
  resources :charges
  resources :venues, only: :index
  resources :locations
  resources :staff, only: [:new, :create, :index, :destroy] do
    patch :create_multiple, on: :collection
  end
  resources :contractors, except: [:edit, :update, :show] do
    patch :create_multiple, on: :collection
  end

  resource :dashboard, only: :show
  resources :service_requests, except: [:edit, :update, :destroy]
  
  resources :location, module: 'location', only: [] do
    resources :equipment_items, only: [:index]
  end
  
  resources :current_requests, only: [:index, :show] do
    get :cancel
  end
  
  namespace :service_requests do
    resources :service_request_assignments do
      get :start_accepting
      post :payment_authorize
    end
  end
  
  authenticated :customer do
    root 'dashboards#show', as: :authenticated_root
  end

  root :to => 'pages#show', id: 'home'

end
