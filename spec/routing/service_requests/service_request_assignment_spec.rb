require 'rails_helper'

RSpec.describe 'route to service request assignments', type: :routing do
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/start_accepting to service_requests/service_request_assignments#start_accepting to start accepting service request assignment' do
    expect(get: '/service_requests/service_request_assignments/:service_request_assignment_id/start_accepting').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'start_accepting',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/payment_authorize to service_requests/service_request_assignments#payment_authorize for payment authorization' do
    expect(post: '/service_requests/service_request_assignments/:service_request_assignment_id/payment_authorize').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'payment_authorize',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/start_declining to service_requests/service_request_assignments#start_declining to start declining service request assignment' do
    expect(get: '/service_requests/service_request_assignments/:service_request_assignment_id/start_declining').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'start_declining',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/decline to service_requests/service_request_assignments#decline to decline service request assignment' do
    expect(patch: '/service_requests/service_request_assignments/:service_request_assignment_id/decline').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'decline',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/start_accepting_estimation to service_requests/service_request_assignments#start_accepting_estimation to start accepting estimation for service request ' do
    expect(get: '/service_requests/service_request_assignments/:service_request_assignment_id/start_accepting_estimation').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'start_accepting_estimation',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/accept_estimation to service_requests/service_request_assignments#accept_estimation to accept estimation for service request' do
    expect(post: '/service_requests/service_request_assignments/:service_request_assignment_id/accept_estimation').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'accept_estimation',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/consider_estimation to service_requests/service_request_assignments#consider_estimation to consider estimation for service request' do
    expect(get: '/service_requests/service_request_assignments/:service_request_assignment_id/consider_estimation').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'consider_estimation',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/start_declining_estimation to service_requests/service_request_assignments#start_declining_estimation to start declining estimation for service request' do
    expect(get: '/service_requests/service_request_assignments/:service_request_assignment_id/start_declining_estimation').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'start_declining_estimation',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
  
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/decline_estimation to service_requests/service_request_assignments#decline_estimation to start decline estimation for service request' do
    expect(post: '/service_requests/service_request_assignments/:service_request_assignment_id/decline_estimation').to route_to(
      controller: 'service_requests/service_request_assignments',
      action: 'decline_estimation',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
end
