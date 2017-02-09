Rails.application.routes.draw do

  devise_for :customers, path: '', controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords'
  }

  resource :dashboard, only: :show

  root :to => redirect("/sign_in")

end
