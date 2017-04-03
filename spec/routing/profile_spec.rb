require 'rails_helper'

RSpec.describe 'route to profile', type: :routing do
  it 'routes /profile/resend_email_confirmation to profiles#resend_phone_confirmation to send email confirmation' do
    expect(get: '/profile/resend_email_confirmation').to route_to(
      controller: 'profiles',
      action: 'resend_email_confirmation'
    )
  end
  
  it 'routes /profile/resend_phone_confirmation to profiles#resend_phone_confirmation to send phone number confirmation' do
    expect(get: '/profile/resend_phone_confirmation').to route_to(
      controller: 'profiles',
      action: 'resend_phone_confirmation'
    )
  end
  
  it 'routes /profile/confirm_phone to profiles#confirm_phone to confirm phone number' do
    expect(patch: '/profile/confirm_phone').to route_to(
      controller: 'profiles',
      action: 'confirm_phone'
    )
  end
  
  it 'routes /profile/edit to profiles#edit to edit profile details' do
    expect(get: '/profile/edit').to route_to(
      controller: 'profiles',
      action: 'edit'
    )
  end
  
  it 'routes /profile to profiles#show to show profile details' do
    expect(get: '/profile').to route_to(
      controller: 'profiles',
      action: 'show'
    )
  end
  
  it 'routes /profile to profiles#update (patch method) to update profile' do
    expect(patch: '/profile').to route_to(
      controller: 'profiles',
      action: 'update'
    )
  end
  
  it 'routes /profile to profiles#update (put method) to update profile' do
    expect(put: '/profile').to route_to(
      controller: 'profiles',
      action: 'update'
    )
  end
  
end                                  
                                
