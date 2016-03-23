module BrowserHeaders
  class Headers
    def initialize(redis, config)
      @redis = redis
      @config = config
    end

    def update_headers
      if @last_update
        uri = URI.parse("#{@config.server_url}" \
          "?since=#{@last_update.strftime('%F')}")
      else
        uri = URI.parse(@config.server_url.to_s)
      end
      response = @config.login ? download_login(uri) : download(uri)
      headers_count = @redis.zcard('headers') + 1
      parsed = JSON.parse(response.body)
      parsed.each_with_index do |browser, index|
        unless @redis.zrank('headers', browser['header'])
          @redis.zadd('headers', index + headers_count, browser['header'])
        end
      end
      @last_update = DateTime.now
    end

    def download(uri)
      req = Net::HTTP::Get.new uri
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      response
    end

    def download_login(uri)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @config.login, @config.password
      response = Net::HTTP.start(uri.hostname, uri.port,
                                 :use_ssl => uri.scheme == 'https') do |http|
        http.request(req)
      end
      response
    end

    def get_headers(number)
      @redis.zrange('headers', -number, -1)
    end
  end
end
