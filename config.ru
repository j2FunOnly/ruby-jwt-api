require_relative 'main'

run Rack::URLMap.new({
  '/' => Public,
  '/api' => Api
})
