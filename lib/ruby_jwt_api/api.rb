module RubyJWTAPI
  class Api < Sinatra::Base
    use JwtAuth

    def initialize
      super

      @accounts = {
        user1: 100,
        user2: 200,
        user3: 300
      }
    end

    get '/money' do
      scopes, user = request.env.values_at :scopes, :user
      username = user['username'].to_sym

      if scopes.include?('view_money') && @accounts.has_key?(username)
        content_type :json
        {money: @accounts[username]}.to_json
      else
        halt 403
      end
    end
  end
end
