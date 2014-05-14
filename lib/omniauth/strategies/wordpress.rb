require 'omniauth-oauth2'
require 'pp'

module OmniAuth
  module Strategies
    class Wordpress < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, 'wordpress'

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, { token_url: "/oauth/request_token", access_url: "/oauth/request_access"}


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
        puts access_token.get('/oauth/request_access').inspect
        access_token.get('/oauth/request_access').parsed
      end
    end
  end
end