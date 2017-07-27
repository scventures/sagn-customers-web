module Helpers
  def user_agent
    "SAGN Customers Web app Revision-#{`git rev-parse --short HEAD`.strip}#{' (development-env)' if Rails.env.development?}"
  end
  
  def stub_auth_api_request(email, password, return_body, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/auth_token").
       with(:body => {'auth'=>{'email'=> email, 'password'=> password}},
            :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
       to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end

  def stub_verified_api_request(auth_token, return_body, response_code)
    stub_request(:get, "#{ENV['API_URL']}/customers/viewer").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_password_reset_instructions(email, return_url, response_code, return_body)
    stub_request(:post, "#{ENV['API_URL']}/customers/password").
      with(:body => {'customer'=>{'email'=> email, 'redirect_url'=> return_url}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end
  
  def stub_password_reset_request(password, password_confirmation, reset_password_token, response_code, return_body)
    stub_request(:put, "#{ENV['API_URL']}/customers/password").
      with(:body => {'customer'=>{'password'=> password, 'password_confirmation'=> password_confirmation, 'reset_password_token'=> reset_password_token}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_confirm_by_token_request(token, response_code, return_body)
    stub_request(:get, "#{ENV['API_URL']}/customers/confirmation?confirmation_token=#{token}").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_send_confirmation_instructions(email, redirect_url, response_code, return_body)
    stub_request(:post, "#{ENV['API_URL']}/customers/confirmation").
     with(:body => {'customer'=>{'email'=> email, 'redirect_url'=> redirect_url}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
     to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_resend_phone_confirmation_instructions(unconfirmed_phone, response_code, return_body)
    stub_request(:put, "#{ENV['API_URL']}/customers/viewer/confirm_phone").
      with(:body => {'customer'=>{'unconfirmed_phone'=> unconfirmed_phone}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_verify_phone(sms_pin, response_code, return_body)
    stub_request(:post, "#{ENV['API_URL']}/customers/viewer/confirm_phone").
      with(:body => {'sms_confirmation_pin'=>sms_pin},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_layer_identity_token(nonce, return_body, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/layer/identity").
         with(:body => {"nonce"=>nonce},
              :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
         to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end
  
  def stub_start_accepting_assignment(id, account_id, service_request_id, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/start_accepting").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_accept_assignment(id, account_id, service_request_id, token, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/accept").
      with(:body => {'stripe_token'=> token}, :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_decline_assignment(id, account_id, service_request_id, reason, response_code, new_search)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/decline").
      with(:body => {'account_id'=> account_id.to_s, 'id'=> id.to_s, 'reason'=> reason, 'new_search': new_search, 'service_request_id'=> service_request_id.to_s }, :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_start_accepting_estimation(id, account_id, service_request_id, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/start_accepting_estimation").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_accept_estimation(id, account_id, service_request_id, token, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/accept_estimation").
      with(:body => {'stripe_token'=> token}, :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_decline_estimation(id, account_id, service_request_id, reason, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/decline_estimation").
      with(:body => {'reason'=> reason }, :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_consider_estimation(id, account_id, service_request_id, response_code)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/consider_estimation").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => {}.to_json, :headers => {})
  end
  
  def stub_cancel_service_request(id, account_id, response_code, return_body)
    stub_request(:put, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{id}/cancel").
       with(:body => {'account_id'=> account_id.to_s, 'id' => id.to_s},
            :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
       to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_venue_images(id, response_code, return_body)
    stub_request(:get, "https://#{ENV['BASIC_AUTH_USERNAME']}:#{ENV['BASIC_AUTH_PASSWORD']}@stapp.sendaguy.com/api/customers/venue_photos?limit=1&venue_id=#{id}").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=> user_agent}).
       to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_get_customer_account(id, response_code, return_body)
    stub_request(:get, "#{ENV['API_URL']}/customers/accounts/#{id}").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_customer_locations(account_id, response_code, return_body)
    stub_request(:get, "#{ENV['API_URL']}/customers/accounts/#{account_id}/locations").
         with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Authorization'=>"Bearer #{jwt}", 'User-Agent'=> user_agent}).
         to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end
  
  def stub_create_location(account_id, params, response_code, return_body)
     stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{account_id}/locations").
       with(:body => {'location'=> params},
            :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>"Bearer #{jwt}", 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
       to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_create_service_request(service_request, response_code, return_body)
    stub_request(:post, "#{ENV['API_URL']}/customers/accounts/#{service_request.account_id}/service_requests").
      with(:body => {'service_request'=> service_request.attributes },
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=> "Bearer #{jwt}", 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_update_password(current_password, password, password_confirmation, response_code, return_body)
    stub_request(:put, "#{ENV['API_URL']}/customers/viewer/update_password").
       with(:body => {'customer'=> { current_password: current_password, password: password, password_confirmation: password_confirmation}},
            :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>"Bearer #{jwt}", 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> user_agent}).
       to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_service_request_assignments(account_id, service_request_id)
    stub_request(:get, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments").
       with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'User-Agent'=> user_agent}).
       to_return(:status => 200, :body => assignments, :headers => {})
  end
  
  def stub_service_request_assignment(account_id, service_request_id, assignment_id)
    stub_request(:get, "#{ENV['API_URL']}/customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{assignment_id}").
       with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'User-Agent'=> user_agent}).
       to_return(:status => 200, :body => assignment, :headers => {})
  end
  
  def stub_geocoder_request
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=Address%203&language=en&sensor=false").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "".to_json, :headers => {})
  end

  def customer_account
    {
      'customer_account': {
        'id': 1,
        'name': 'Test',
        'phone_number': nil,
        'have_payment_method': true,
        'owner_name': 'Test',
        'owner_email': 'test@gmail.com',
        'messenger_channel_id': 'layer:///conversations/e7b0ea4b-850d-4a3a-987f-25e03d2da9f0'
      }
    }.to_json
  end
  
  def customer_location
    {
      'location': {
        'id': 3,
        'name': 'Test',
        'address_1': 'Address',
        'address_2': nil,
        'address_3': nil,
        'city': nil,
        'state': nil,
        'zip': nil,
        'phone_number': nil,
        'geography': {
          'latitude': 11.11,
          'longitude': 11.11
        },
        'foursquare_venue_id': nil,
        'equipment_items': []
      }
    }.to_json
  end
  
  def location_with_name_error
    {
      'name': [
        'Location already exists'
      ]
    }.to_json
  end
  
  def location_with_address_error
    {
      'address_1': [
        'Location already exists'
      ]
    }.to_json
  end
  
  def customer_locations
    {
      'locations': [
        {
          'id': 2,
          'name': 'Test Location 1',
          'address_1': 'Address 1',
          'address_2': '',
          'address_3': '',
          'city': 'city',
          'state': 'state',
          'zip': '10016',
          'phone_number': '+12125096995',
          'geography': {
            'latitude': 38.58875100724594,
            'longitude': -117.72847970429468
          },
          'foursquare_venue_id': nil
        },
        {
          'id': 2,
          'name': 'Test Location 2',
          'address_1': 'Address 2',
          'address_2': '',
          'address_3': '',
          'city': 'city',
          'state': 'state',
          'zip': '10016',
          'phone_number': '+12125096995',
          'geography': {
            'latitude': 38.58875100724594,
            'longitude': -117.72847970429468
          },
          'foursquare_venue_id': 'test'
        }
      ]
    }
  end
  
  def verified_return_body
    {
      'customer': {
        'id': 1,
        'name': 'Test',
        'phone_number': '+111111111',
        'unconfirmed_phone': '',
        'photo': 'test.png',
        'email': 'test@gmail.com',
        'unconfirmed_email': '',
        'current_account_id': 1,
        'active': true,
        'current_account_role': 'account_owner',
        'customer_account_ids': [
          1
        ],
        'mapping_enabled': false,
        'confirmed': true
       }
     }.to_json
  end
  
  def get_equipment_return_body
    {
      'equipment_item': {
        'id': 325,
        'model': nil,
        'serial': nil,
        'brand_name': 'Other',
        'location_id': 125,
        'category': {
          'id': 376,
          'name': 'Kitchen Equipment',
          'parent_category_id': nil,
          'problem_codes': [],
          'brands': [],
          'is_equipment': true,
          'sub_brands': [
            {
              'id': 22,
              'name': 'Delfield',
              'warranty_phone_number': '1-844-724-2273',
              'notes': 'Address:980 South Isabella Rd Mt. Pleasant, MI, 48858\r\nPhone Number:800-733-8821\r\nFax Number:800-669-0619\r\nEmail: http://www.delfield.com/minisite/contact/default\r\n',
              'created_at': '2015-11-10T08:37:03-05:00',
              'updated_at': '2016-02-12T15:12:40-05:00',
              'company_website_url': 'http://www.delfield.com/',
              'warranty_lookup_url': 'http://www.delfield.com/minisite/warranty',
              'asa_url': '',
              'deleted_at': nil
            },        
            {
              'id': 172,
              'name': 'German Knife',
              'warranty_phone_number': '1-800-500-3519 ',
              'notes': 'Address:\r\nGerman Knife, Inc.\r\n4184 E. Conant Street\r\nLong Beach, CA 90808\r\n\r\nPhone Number:\r\n310-900-1081\r\n800-500-3519\r\n\r\nFax Number:\r\n310-900-1066\r\n\r\nEmail:\r\ngkrsvc@turboairinc.com',
              'created_at': '2016-02-22T11:49:09-05:00',
              'updated_at': '2016-02-22T13:25:47-05:00',
              'company_website_url': 'http://www.turboairinc.com/',
              'warranty_lookup_url': '',
              'asa_url': '',
              'deleted_at': nil
            }
          ],
          'manual_processing': false
        },
        'subcategory': {
          'id': 396,
          'name': 'Slicer',
          'parent_category_id': 376,
          'problem_codes': [],
          'brands': [
            {
              'id': 9,
              'name': 'Hobart',
              'warranty_phone_number': '1-937-332-3000',
              'notes': 'Address:\r\n701 S. Ridge Ave.\r\nTroy, OH 45374\r\n\r\nPhone Number:\r\n888 446-2278\r\n937 332-3000\r\n\r\nFax Number:\r\n937 332-2852',
              'created_at': '2015-11-10T08:37:02-05:00',
              'updated_at': '2016-02-12T16:49:17-05:00',
              'company_website_url': 'http://www.hobartservice.com/',
              'warranty_lookup_url': '',
              'asa_url': '',
              'deleted_at': nil
            },
            {
              'id': 2,
              'name': 'Vollrath',
              'warranty_phone_number': '1-800-628-0832',
              'notes': 'Address:\r\n1236 N. 18th Street\r\nSheboygan, WI 53081\r\n\r\nPhone Number:\r\n920 457-4851\r\n800 624-2051\r\n800 628-0830 (Customer Service)\r\n800 628-0832 (Tech Service)\r\n\r\nFax Number:\r\n920 459-6573\r\n\r\nEmail:\r\nvollrathfs@vollrathco.com\r\ntechservicereps@vollrathco.com\r\n\r\nAdditional Contact Information: http://vollrath.com/Vollrath/Contact-Us/Contact-Vollrath-Foodservice-USA.htm',
              'created_at': '2015-10-26T19:18:27-04:00',
              'updated_at': '2016-02-16T11:14:42-05:00',
              'company_website_url': 'http://vollrath.com/Vollrath.htm',
              'warranty_lookup_url': ' http://vollrath.com/Vollrath/Parts-Support/Warranty-Information.htm ',
              'asa_url': '',
              'deleted_at': nil
            },
          ],
          'manual_processing': false
        },
        'brand': nil
      }
    }
  end
  
  def already_confirmed_email_body
    {
      'email': [
        'was already confirmed, please try signing in'
      ]
    }.to_json
  end
  
  def invalid_confirmation_token_body
    {
      'confirmation_token': [
        'is invalid'
      ]
    }.to_json
  end
  
  def confirmation_instructions_valid_body
    {
      'customer': {
        'id': 323,
        'name': 'test',
        'phone_number': '',
        'unconfirmed_phone': '+111111111111',
        'photo': nil,
        'email': 'test@gmail.com',
        'unconfirmed_email': nil,
        'current_account_id': 241,
        'active': false,
        'current_account_role': 'account_owner',
        'customer_account_ids': [
          241
        ],
        'mapping_enabled': false
      }
    }.to_json
  end
  
  def confirmation_instructions_invalid_body
    {
      'email': [
        'not found'
      ]
    }.to_json
  end
  
  def resend_phone_confirmation_invalid_body
    {
      'unconfirmed_phone': [
        'is an invalid number'
      ],
      'phone_number': [
        'is an invalid number'
      ]
    }.to_json
  end
  
  def jwt
    payload = {data: 'test@gmail.com'}
    JWT.encode payload, nil, 'none'
  end
  
  def cancel_service_request_error
    {
      'base': [
        'Unable to cancel'
      ]
    }.to_json
  end
  
  def cancel_service_request_success
    {
      'service_request': {
        'id': 1,
        'urgent': false,
        'model': '',
        'serial': '',
        'notes': '',
        'brand_name': '',
        'is_active': false,
        'status': 'cancelled',
        'latest_activity_status': 'You\'ve cancelled this request',
        'phone_number': '',
        'created_at': '2017-05-11T06:32:38-04:00',
        'test_request': false,
        'declines_remains': 2,
        'is_details_confirmed': false,
        'fix_notes': nil,
        'work_time_details': '',
        'contact_details': '',
        'responded_request_assignment_id': 2,
        'customer_accounts_contractor_id': nil,
        'promo_code': nil,
        'current_job_id': '#1 - 2',
        'can_be_cancelled': false
      }
    }.to_json
  end
  
  def venue_images_success_response
    {
      'count': 1,
      'items': [
        {
          'id': '4fb52765e4b021e74efb55f0',
          'createdAt': 1337272165,
          'source': {
            'name': 'Foursquare for Android',
            'url': 'https://foursquare.com/download/#/android'
          },
          'prefix': 'https://igx.4sqi.net/img/general/',
          'suffix': '/ve2yCAJmaZ3jLybn0DDsVu-f1jwV2udwINjWiqYdj7c.jpg',
          'width': 540,
          'height': 720,
          'user': {
            'id': '10320058',
            'firstName': 'Test',
            'lastName': 'Test',
            'gender': 'male',
            'photo': {
              'prefix': 'https://igx.4sqi.net/img/user/',
              'suffix': '/XZYU0TATEQNKYIOF.jpg'
            }
          },
          'checkin': {
            'id': '4fb52014e4b01063320ffb98',
            'createdAt': 1337270292,
            'type': 'checkin',
            'timeZoneOffset': 330
          },
          'visibility': 'public'
        }
      ],
      'dupesRemoved': 0
    }.to_json
  end
  
  def service_request_body
    {
      'service_request': {
        'id': 1000,
        'urgent': true,
        'model': nil,
        'serial': nil,
        'notes': nil,
        'brand_name': nil,
        'is_active': true,
        'status': 'waiting',
        'latest_activity_status': 'We have received your service request',
        'phone_number': nil,
        'created_at': '2017-06-06T06:47:34-04:00',
        'test_request': false,
        'declines_remains': 2,
        'is_details_confirmed': false,
        'fix_notes': nil,
        'work_time_details': nil,
        'contact_details': nil,
        'responded_request_assignment_id': nil,
        'customer_accounts_contractor_id': nil,
        'promo_code': nil,
        'current_job_id': '',
        'can_be_cancelled': true,
        'category': {
          'id': 376,
          'name': 'Kitchen Equipment',
          'parent_category_id': nil,
          'problem_codes': [],
          'brands': [],
          'is_equipment': true,
          'sub_brands': []
        },
        'subcategory': {
          'id': 378,
          'name': 'Char Broiler',
          'parent_category_id': 376,
          'problem_codes': [],
          'brands': []
        },
        'location': {
          'id': 610,
          'name': 'Toby\'s Estate Coffee',
          'address_1': '160 5th Ave',
          'address_2': nil,
          'address_3': nil,
          'city': 'New York',
          'state': 'NY',
          'zip': '10010',
          'phone_number': '+16465590161',
          'geography': {
            'latitude': 40.74008224791916,
            'longitude': -73.990638716365
          },
          'foursquare_venue_id': nil
        },
        'brand': nil,
        'equipment_item': {
          'id': 737,
          'model': nil,
          'serial': nil,
          'brand_name': 'Other',
          'location_id': 610,
          'equipment_name': nil
        },
        'problem_code': nil,
        'responded_request_assignment': nil,
        'service_requests_assignments': [],
        'fix_images': nil,
        'issue_images': []
      }
    }.to_json
  end
  
  def assignments
    {
      'service_requests_assignments': [
        {
          'id': 10
        },
        {
          'id': 11
        }
      ]
    }.to_json
  end
  
  def assignment
    {
      'service_requests_assignment': {
        'id': 10
      }
    }.to_json      
  end
  
  def venue_images_error_response
    {
      'error': 'param_error: Value venue_id is invalid for venue id (400)'
    }.to_json
  end
  
  def have_attached_file name
    HaveAttachedFileMatcher.new(name)
  end
  
  class HaveAttachedFileMatcher
    def initialize attachment_name
      @attachment_name = attachment_name
    end
  end
  
end
