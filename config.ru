require_relative 'lib/ruby_jwt_api'

run Rack::URLMap.new({
  '/' => RubyJWTAPI::Public,
  '/api' => RubyJWTAPI::Api
})
