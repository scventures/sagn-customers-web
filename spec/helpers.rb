module Helpers
  def stub_auth_api_request(email, password, return_body, response_code)
    stub_request(:post, 'https://stapp.sendaguy.com/api/customers/auth_token').
      with(:body => {'auth'=>{'email'=> email, 'password'=> password}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end

  def stub_verified_api_request(auth_token, return_body, response_code)
    stub_request(:get, 'https://stapp.sendaguy.com/api/customers/viewer').
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2',  'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_password_reset_instructions(email, return_url, response_code, return_body)
    stub_request(:post, 'https://stapp.sendaguy.com/api/customers/password').
      with(:body => {"customer"=>{'email'=> email, 'redirect_url'=> return_url}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end
  
  def stub_password_reset_request(password, password_confirmation, reset_password_token, response_code, return_body)
    stub_request(:put, 'https://stapp.sendaguy.com/api/customers/password').
      with(:body => {'customer'=>{'reset_password_token' => reset_password_token, 'password'=> password, 'password_confirmation'=> password_confirmation}},
       :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body, :headers => {})

  end

  def verified_return_body
    {
      'customer': {
        'id': 59,
        'name': 'Test',
        'phone_number': '+111111111',
        'unconfirmed_phone': '',
        'photo': 'test.png',
        'email': 'test@gmail.com',
        'unconfirmed_email': '',
        'current_account_id': 43,
        'active': true,
        'current_account_role': 'account_owner',
        'customer_account_ids': [
          43
        ],
        'mapping_enabled': false
       }
     }.to_json
  end
end
