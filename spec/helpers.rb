module Helpers
  def stub_auth_api_request(email, password, return_body, response_code)
    stub_request(:post, "#{Rails.application.secrets.api_url}/customers/auth_token").
      with(:body => {'auth'=>{'email'=> email, 'password'=> password}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end

  def stub_verified_api_request(auth_token, return_body, response_code)
    stub_request(:get, "#{Rails.application.secrets.api_url}/customers/viewer").
      with(:headers => {'Accept'=>'application/json;application/vnd.sagn.v2',  'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body, :headers => {})
  end
  
  def stub_password_reset_instructions(email, return_url, response_code, return_body)
    stub_request(:post, "#{Rails.application.secrets.api_url}/customers/password").
      with(:body => {"customer"=>{'email'=> email, 'redirect_url'=> return_url}},
          :headers => {'Accept'=>'application/json;application/vnd.sagn.v2', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.11.0'}).
      to_return(:status => response_code, :body => return_body.to_json, :headers => {})
  end
  
  def stub_password_reset_request(password, password_confirmation, reset_password_token, response_code, return_body)
     stub_request(:put, "#{Rails.application.secrets.api_url}/customers/password").
       with(:body => {'customer'=>{'password'=> password, 'password_confirmation'=> password_confirmation, 'reset_password_token'=> reset_password_token}},
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
end
