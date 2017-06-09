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
    get :change_password
    patch :update_password
  end
  resources :faqs, only: :index
  resources :charges
  resources :venues, only: :index do
    get :images, on: :member
  end
  resources :locations, except: [:show] do
    resources :service_requests, only: [:new, :create, :edit, :update], module: 'locations'
    resources :equipment_items, only: [:index], module: 'locations'
  end
  resources :staff, only: [:new, :create, :index, :destroy] do
    patch :create_multiple, on: :collection
  end
  resources :contractors, except: [:edit, :update, :show] do
    patch :create_multiple, on: :collection
  end

  resources :service_requests, only: [:index]
  
  resources :current_requests, only: [:index, :show] do
    get :cancel
  end
  
  resources :past_requests, only: [:index, :show]
  
  namespace :service_requests do
    resources :service_request_assignments, only: [] do
      get :start_accepting
      post :payment_authorize
      get :start_declining
      patch :decline
      get :start_accepting_estimation
      post :accept_estimation
      get :consider_estimation
      get :start_declining_estimation
      post :decline_estimation
      resources :customer_ratings, module: 'service_request_assignments', only: [:create]
    end
  end
  
  authenticated :customer do
    root 'service_requests#index', as: :authenticated_root
  end
  
  root :to => 'customers#new'
  get "/pages/*id" => 'pages#show', format: false, as: :page
end
