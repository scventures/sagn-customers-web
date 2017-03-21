Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords',
    registrations: 'customers/registrations',
    confirmations: 'customers/confirmations'
  }
  
  resources :locations, only: [:new, :create, :show]
  resources :staffs, only: [:new, :create, :index]

  resource :dashboard, only: :show
  resources :service_requests, only: [:new, :create, :show]
  
  resources :location, module: 'location', only: [] do
    resources :equipment_items, only: [:index]
  end

  root :to => redirect('/sign_in')

end
