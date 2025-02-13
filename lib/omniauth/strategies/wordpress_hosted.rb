require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class WordpressHosted < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, 'wordpress_hosted'

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {  }


      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['ID'] }

      info do
        {
            name: raw_info['display_name'],
            email: raw_info['user_email'],
            nickname: raw_info['user_nicename'],
            urls: { "Website" => raw_info['user_url'] }
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        puts access_token.token
        @raw_info ||= access_token.get(
          "/oauth/me",
          :params => { 'Authorization' =>
                       "Bearer #{access_token.token}"
                       }
        ).parsed
      end

    protected

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier)
        #client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
      end
    end
  end
end
