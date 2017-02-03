module Devise
  module Strategies
    class RemoteAuthenticatable < Authenticatable
      def authenticate!
        auth_params = authentication_hash
        auth_params[:password] = password

        resource = mapping.to.new

        return fail! unless resource

        if validate(resource){ resource.remote_authentication(auth_params) }
          success!(resource)
        end
      end
    end
  end
end
