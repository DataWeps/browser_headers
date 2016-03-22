Gem::Specification.new do |s|
  s.name        = 'browser_headers'
  s.version     = '0.0.0'
  s.date        = '2016-03-20'
  s.summary     = 'Browser Headers'
  s.description = 'Gem for downloading current browser headers'
  s.authors     = ['Jan Mosat']
  s.email       = 'mosat@weps.cz'
  s.files       = ['lib/browser_headers.rb', 'lib/helpers/configuration.rb']
  s.add_runtime_dependency 'redis', '~>3.2'
#  s.homepage    =
#    'http://rubygems.org/gems/hola'
#  s.license       = 'MIT'
end
