require 'rspec'
require 'browser_headers'

describe BrowserHeaders do
  context 'get data from' do
    before(:context) do
      @headers = BrowserHeaders::Client.new(
        redis_host: '127.0.0.1',
        redis_port: '6379',
        redis_db: '0',
        server_url: 'http://127.0.0.1:3000/'
      )
      @redis = Redis.new
      @redis.del('headers')
    end

    it 'connects to redis' do
      expect(@headers.ping).to eq('PONG')
    end

    it 'downloads headers' do
      @headers.fetch_headers
      expect(@redis.zcard('headers')).to be > 0
    end

    it 'returns correct number of headers' do
      number = 20
      headers = @headers.get_headers(20)
      expect(headers.size).to eq(number)
    end

    it 'does not duplicate headers' do
      @headers.fetch_headers
      header_count = @redis.zcard('headers')
      @headers.fetch_headers
      header_count -= @redis.zcard('headers')
      expect(header_count).to be 0
    end

    it 'updates time of last download' do
      @headers.fetch_headers
      first_date = @headers.instance_variable_get(:@headers)
                           .instance_variable_get(:@last_update)
      @headers.fetch_headers
      second_date = @headers.instance_variable_get(:@headers)
                            .instance_variable_get(:@last_update)
      expect(second_date).to be > first_date
    end
  end
end
