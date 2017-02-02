Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    get 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
