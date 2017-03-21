require 'rails_helper'

RSpec.describe 'Customer routes', type: :routing do
  describe 'sessions routes' do
    it 'routes /sign_in to customers/sessions#new to show signin page' do
      expect(get: '/sign_in').to route_to(
        controller: 'customers/sessions',
        action: 'new'
      )
    end
    
    it 'routes /sign_in to customers/sessions#create to signin customer' do
      expect(post: '/sign_in').to route_to(
        controller: 'customers/sessions',
        action: 'create'
      )
    end
    
    it 'routes /sign_out to customers/sessions#destroy to signout customer' do
      expect(delete: '/sign_out').to route_to(
        controller: 'customers/sessions',
        action: 'destroy'
      )
    end
  end
  describe 'passwords routes' do
    it 'routes /password/edit to customers/passwords#edit to edit customer password' do
      expect(get: '/password/edit').to route_to(
        controller: 'customers/passwords',
        action: 'edit'
      )
    end
    
    it 'routes /password to customers/passwords#update to update(patch method) customer password' do
      expect(patch: '/password').to route_to(
        controller: 'customers/passwords',
        action: 'update'
      )
    end
    
    it 'routes /password to customers/passwords#update(put method) to update customer password' do
      expect(put: '/password').to route_to(
        controller: 'customers/passwords',
        action: 'update'
      )
    end
    
    it 'routes /password to customers/passwords#create to create customer password' do
      expect(post: '/password').to route_to(
        controller: 'customers/passwords',
        action: 'create'
      )
    end
  end
  
  describe 'registrations routes' do
    it 'routes /cancel to customers/registrations#cancel to cancel customer registration' do
      expect(get: '/cancel').to route_to(
        controller: 'customers/registrations',
        action: 'cancel'
      )
    end
    
    it 'routes /sign_up to customers/registrations#new to signup customer' do
      expect(get: '/sign_up').to route_to(
        controller: 'customers/registrations',
        action: 'new'
      )
    end
    
    it 'routes /edit to customers/registrations#edit to edit customer' do
      expect(get: '/edit').to route_to(
        controller: 'customers/registrations',
        action: 'edit'
      )
    end
    
    it 'routes / to customers/registrations#update to update(patch method) customer' do
      expect(patch: '/').to route_to(
        controller: 'customers/registrations',
        action: 'update'
      )
    end
    
    it 'routes / to customers/registrations#update to update(put method) customer' do
      expect(put: '/').to route_to(
        controller: 'customers/registrations',
        action: 'update'
      )
    end
    
    it 'routes / to customers/registrations#destroy to destroy customer' do
      expect(delete: '/').to route_to(
        controller: 'customers/registrations',
        action: 'destroy'
      )
    end
    
    it 'routes / to customers/registrations#create to create customer' do
      expect(post: '/').to route_to(
        controller: 'customers/registrations',
        action: 'create'
      )
    end
  end
  
  describe 'confirmations routes' do
    it 'routes /confirmation/new to customers/confirmations#new for customer confirmation' do
      expect(get: '/confirmation/new').to route_to(
        controller: 'customers/confirmations',
        action: 'new'
      )
    end
    
    it 'routes /confirmation to customers/confirmations#show to show customer confirmation' do
      expect(get: '/confirmation').to route_to(
        controller: 'customers/confirmations',
        action: 'show'
      )
    end
    
    it 'routes /confirmation to customers/confirmations#create to create customer confirmation' do
      expect(post: '/confirmation').to route_to(
        controller: 'customers/confirmations',
        action: 'create'
      )
    end
  end

end
