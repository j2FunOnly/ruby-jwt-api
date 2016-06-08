module RubyJWTAPI
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
        # {message: 'Successfully logged in!'}.to_json
        {token: token(username)}.to_json
      else
        halt 401
      end
    end

    private

    def token(username)
      JWT.encode payload(username), ENV['JWT_SECRET'], 'HS256'
    end

    def payload(username)
      current_time = Time.now.to_i
      {
        exp: current_time + 60 * 60,
        iat: current_time,
        iss: ENV['JWT_ISSUER'],
        scopes: ['add_money', 'remove_money', 'view_money'],
        user: {
          username: username
        }
      }
    end
  end
end
