module BrowserHeaders
  class Client
    class Configuration
      VALID_CONFIGURATION =
          [
              :redis_url,
              :redis_host,
              :redis_port,
              :redis_db,
              :server_url,
              :login,
              :password
          ]

      attr_accessor *VALID_CONFIGURATION

      def configure
        yield self
      end

      def reset
        @es = nil
      end

      # print config
      def config
        config = {}
        VALID_CONFIGURATION.each do |config_key|
          config[config_key] = send(config_key)
        end
        config
      end
    end
  end
end