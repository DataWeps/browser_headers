# encoding:utf-8
require 'helpers/configuration'
require 'redis'
require 'helpers/headers'

OpenSSL::SSL::VERIFY_PEER ||= OpenSSL::SSL::VERIFY_NONE

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
      @headers = Headers.new(@redis, @config)
    end

    def ini_redis
      @redis =
        if @config.redis_url
          Redis.new(:url => @config.redis_url)
        elsif @config.redis_host && @config.redis_port && @config.redis_db
          Redis.new(:host => @config.redis_host,
                    :port => @config.redis_port,
                    :db => @config.redis_db)
        else
          Redis.new
        end
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

    def get_random_header
      @headers.get_random_header
    end
  end
end
