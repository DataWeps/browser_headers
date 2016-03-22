require 'helpers/configuration'
require 'redis'
require 'json'
require 'net/http'
require 'date'

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
        @redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port, :db => @config.redis_db)
      else
        @redis = Redis.new
      end
    end

    def ping
      puts @redis.ping
    end

    def config
      @config.config
    end

    def fetch_headers
      uri = @last_update ? URI.parse("#{@config.server_url}?since=#{@last_update.strftime('%F')}") : URI.parse(@config.server_url)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @config.login, @config.password
      response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
        http.request(req)
      }
      i = @redis.zcard('headers') + 1
      parsed = JSON.parse(response.body)
      parsed.each do |x|
        @redis.zadd('headers',i,x['header']) unless @redis.zrank('headers',x['header'])
        i += 1
      end
      @last_update = DateTime.now
    end

    def get_headers(number)
      @redis.zrange('headers', -number , -1)
    end
  end
end