module Devise
  module Models
    module RemoteAuthenticatable
      extend ActiveSupport::Concern

      def remote_authentication(authentication_hash)
        # Your logic to authenticate with the external webservice
      end
    end
  end
end

