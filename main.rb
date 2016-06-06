require 'json'
require 'jwt'
require 'sinatra/base'

class Api < Sinatra::Base
  def initialize
    super

    @account = {
      user1: 100,
      user2: 200,
      user3: 300
    }
  end

  get '/money' do
    content_type :json
    {message: 'Hello World'}.to_json
  end
end

class Public < Sinatra::Base
  def initialize
    super

    @logins = {
      user1: 'password1',
      user2: 'password2',
      user3: 'password3'
    }
  end

  post '/login' do
    username = params[:username]
    password = params[:password]

    if @logins[username.to_sym] == password
      content_type :json
      {message: 'Successfully logged in!'}.to_json
    else
      halt 401
    end
  end
end
