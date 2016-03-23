require 'helpers/configuration'
require 'redis'
require 'helpers/headers'

module BrowserHeaders
  class Client
    def initialize(params = {}, &block)
      @config = Configuration.new
      if block_given?
        @config.configure(&block)
      else
        params.each do |key, value|
          @config.instance_variable_set(:"@#{key}", value)
        end
      end
      ini_redis
    end

    def ini_redis
      if @config.redis_url
        @redis = Redis.new(:url => @config.redis_url)
      elsif @config.redis_host && @config.redis_port && @config.redis_db
        @redis = Redis.new(:host => @config.redis_host,
                           :port => @config.redis_port,
                           :db => @config.redis_db)
      else
        @redis = Redis.new
      end
      @headers = Headers.new(@redis, @config)
    end

    def ping
      @redis.ping
    end

    def config
      @config.config
    end

    def fetch_headers
      @headers.update_headers
    end

    def get_headers(number)
      @headers.get_headers(number)
    end
  end
end
