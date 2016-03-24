require 'rspec'
require 'browser_headers'
require 'net/http'

describe BrowserHeaders do
  context 'browser_headers gem' do
    let(:headers) do
      BrowserHeaders::Client.new(
        redis_host: '127.0.0.1',
        redis_port: '6379',
        redis_db: '0',
        server_url: 'http://127.0.0.1:3000/',
        login: 'admin',
        password: 'admin'
      )
    end
    let(:redis) { Redis.new }

    it 'connects to redis' do
      expect(headers.ping).to eq('PONG')
    end

    it 'downloads headers' do
      headers.fetch_headers
      expect(redis.zcard('headers')).to be > 0
    end

    it 'returns correct number of headers' do
      number = 20
      headers.fetch_headers
      headers_list = headers.get_headers(20)
      expect(headers_list.size).to eq(number)
    end

    it 'does not duplicate headers' do
      headers.fetch_headers
      header_count = redis.zcard('headers')
      headers.fetch_headers
      header_count -= redis.zcard('headers')
      expect(header_count).to be 0
    end

    it 'updates time of last download' do
      headers.fetch_headers
      first_date = headers.instance_variable_get(:@headers)
                          .instance_variable_get(:@last_update)
      headers.fetch_headers
      second_date = headers.instance_variable_get(:@headers)
                           .instance_variable_get(:@last_update)
      expect(second_date).to be > first_date
    end

    it 'creates correct uri' do
      headers.fetch_headers
      headers_helper = headers.instance_variable_get(:@headers)
      last_update = headers_helper.instance_variable_get(:@last_update)
      uri = headers_helper.make_uri
      expect(uri.query).to eq("since=#{last_update.strftime('%F')}")
    end

    after(:each) { Redis.new.del('headers') }
  end
end
