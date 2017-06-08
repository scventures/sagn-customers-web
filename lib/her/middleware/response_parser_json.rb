module Her
  module Middleware
    # This middleware treat the received first-level JSON structure as the resource data.
    class ResponseParserJSON < ParseJSON
      # Parse the response body
      #
      # @param [String] body The response body
      # @return [Mixed] the parsed response
      # @private
      def parse(body)
        json = parse_json(body)
        errors = json.delete(:errors) || {}
        metadata = json.delete(:metadata) || {}
        {
          :data => json,
          :errors => errors,
          :metadata => metadata
        }
      end

      # This method is triggered when the response has been received. It modifies
      # the value of `env[:body]`.
      #
      # @param [Hash] env The response environment
      # @private
      def on_complete(env)
        env[:body] = case env[:status]
        when 204
          parse('{}')
        when 422, 400
          parse("{\"errors\": #{env[:body]}}")
        when 401
          raise Warden::NotAuthenticated
        else
          parse(env[:body])
        end
      end
    end
  end
end
