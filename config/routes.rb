Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords'
  }

  resource :dashboard, only: :show
  resource :service_requests, only: [:new, :create]
  resource :locations, only: [] do
    get :equipments, on: :member
  end

  root :to => redirect("/sign_in")

end
