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
  resources :locations, only: [:new, :create, :show]
  resources :staff, only: [:new, :create, :index, :destroy]

  resource :dashboard, only: :show
  resources :service_requests, only: [:new, :create, :show]
  
  resources :location, module: 'location', only: [] do
    resources :equipment_items, only: [:index]
  end

  root :to => redirect('/sign_in')

end
