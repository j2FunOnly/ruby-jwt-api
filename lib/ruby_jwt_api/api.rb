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
      process_request request, 'view_money'
    end

    post '/money' do
      process_request request, 'add_money' do |username|
        amount = params[:amount].to_i
        @accounts[username] += amount
      end
    end

    delete '/money' do
      process_request request, 'remove_money' do |username|
        amount = params[:amount].to_i
        @accounts[username] -= amount
      end
    end

    private

    def process_request req, scope
      scopes, user = req.env.values_at :scopes, :user
      username = user['username'].to_sym

      halt(403) unless scopes.include?(scope) && @accounts.has_key?(username)

      yield username if block_given?

      show_amount username
    end

    def show_amount(username)
      content_type :json
      {money: @accounts[username]}.to_json
    end
  end
end
