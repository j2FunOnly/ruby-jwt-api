require 'json'
require 'jwt'
require 'sinatra/base'

require_relative 'ruby_jwt_api/jwt_auth'
require_relative 'ruby_jwt_api/api'
require_relative 'ruby_jwt_api/public'

module RubyJWTAPI
  VERSION = '0.0.1'.freeze
end
