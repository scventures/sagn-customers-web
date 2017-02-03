module Devise
  module Models
    module RemoteAuthenticatable
      extend ActiveSupport::Concern
      
      def remote_authentication(authentication_hash)
        customer = Customer.authenticate!(authentication_hash[:email], authentication_hash[:password])
        if customer and customer.valid_auth_token?
          self.jwt = customer.jwt
        else
          nil
        end
      end


      module ClassMethods
        def serialize_from_session(key, auth_token)
          customer = Customer.new(jwt: auth_token)
          customer.valid_auth_token? ? customer : nil
        end

        def serialize_into_session(record)
          [[:auth_token], record.jwt]
        end

      end
    end
  end
end

