Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords',
    registrations: 'customers/registrations',
    confirmations: 'customers/confirmations'
  }

  resources :customers, only: :new do
    collection do
      post :layer_identity
    end
  end
  
  devise_scope :customer do
    post '/customers/create_with_service_request', to: 'customers/registrations#create_with_service_request'
    post '/customers/create_serivce_request_with_login', to: 'customers/sessions#create_service_request_with_login'
  end

  resource :profile, only: [:show, :edit, :update] do
    get :resend_email_confirmation
    get :resend_phone_confirmation
    patch :confirm_phone
  end
  resources :charges
  resources :venues, only: :index
  resources :locations do
    resources :service_requests, only: [:new, :create, :edit, :update], module: 'locations'
    resources :equipment_items, only: [:index], module: 'locations'
  end
  resources :staff, only: [:new, :create, :index, :destroy] do
    patch :create_multiple, on: :collection
  end
  resources :contractors, except: [:edit, :update, :show] do
    patch :create_multiple, on: :collection
  end

  resource :dashboard, only: :show
  resources :service_requests, only: [:index, :show]
  
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
  
  resources :service_request, only: [] do
    resources :assignments, module: 'service_request', only: [] do
      get :accept
    end
  end

  root :to => 'customers#new'
  get "/pages/*id" => 'pages#show', format: false
end
