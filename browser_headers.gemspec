Gem::Specification.new do |s|
  s.name        = 'browser_headers'
  s.version     = '0.0.1'
  s.date        = '2016-03-20'
  s.summary     = 'Browser Headers'
  s.description = 'Gem for downloading current browser headers'
  s.authors     = ['Jan Mosat']
  s.email       = 'mosat@weps.cz'
  s.files       = ['lib/browser_headers.rb', 'lib/helpers/configuration.rb',
                   'lib/helpers/headers.rb']
  s.add_runtime_dependency 'redis'
  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rake', '~> 11.0 '
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-mocks', '~> 3.4'
  s.add_development_dependency 'rubocop', '~> 0.38.0'
  s.homepage      = 'http://dataweps.cz'
  s.license       = 'MIT'
end
