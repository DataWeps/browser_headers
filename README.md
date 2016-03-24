# BrowserHeaders

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'browser_headers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install browser_headers

## Usage

### Configuration:

Please include trailing "/" in server_url
```ruby
headers = BrowserHeaders::Client.new(
    redis_host: '127.0.0.1',
    redis_port: '6379',
    redis_db: '0',
    server_url: 'https://myuseragentweb.cz/',
    login: 'name',
    password: 'password'
)
```

### Futures:

Updates headers in redis database from server

```ruby
headers.fetch_headers
```

Gets specified number of headers from redis database 

```ruby
headers.get_headers(3)
```