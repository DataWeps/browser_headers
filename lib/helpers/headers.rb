require 'json'
require 'net/http'
require 'date'
require 'redis'

module BrowserHeaders
  class Headers
    def initialize(redis, config)
      @redis = redis
      @config = config
    end

    def update_headers
      uri = make_uri
      response = download_login(uri)
      headers_count = @redis.zcard('headers') + 1
      parsed = JSON.parse(response.body)
      parsed.each_with_index do |browser, index|
        unless @redis.zrank('headers', browser['header'])
          @redis.zadd('headers', index + headers_count, browser['header'])
        end
      end
      @last_update = DateTime.now
    end

    def make_uri
      if @last_update
        URI.parse("#{@config.server_url}" \
          "?since=#{@last_update.strftime('%F')}")
      else
        URI.parse(@config.server_url.to_s)
      end
    end

    def download_login(uri)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @config.login, @config.password
      Net::HTTP.start(uri.hostname, uri.port,
                                 :use_ssl => uri.scheme == 'https') do |http|
        http.request(req)
      end
    end

    def get_headers(number)
      @redis.zrange('headers', -number, -1)
    end
  end
end
