Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords'
  }

  resource :dashboard, only: :show
  resource :service_requests, only: [:new, :create, :show]
  resource :equipment_item, only: [:show]

  root :to => redirect("/sign_in")

end
