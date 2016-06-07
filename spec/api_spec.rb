RSpec.describe RubyJWTAPI::Api do
  let(:app) { described_class }

  describe 'with valid token' do
    it 'return money amount for autheticated user' do
      login = Rack::Test::Session.new(Rack::MockSession.new(RubyJWTAPI::Public))
      login.post '/login', username: 'user1', password: 'password1'
      res = login.last_response
      expect(res).to be_ok
      token = 'Basic '
      token << JSON.parse(login.last_response.body)['token']

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 200
      expect(last_response.body).to match 'money'
    end
  end

  describe 'with invalid token', :include_helpers do
    it 'return 401 when token invalid' do
      get '/money', {}, {'HTTP_AUTHORIZATION' => 'invalid_token'}
      expect(last_response.status).to eq 401
      expect(last_response.body).to eq 'A Token must be passed.'
    end

    it 'return 403 when token has expired' do
      token = get_token :user1 do |payload|
        payload[:exp] = Time.now.to_i - 60 * 60
      end

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token has expired.'
    end

    it 'return 403 when token has wrong iat value' do
      token = get_token :user1 do |payload|
        payload[:iat] = Time.now.to_i + 60 * 60 * 10
      end

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token does not have a valid "issued at" time.'
    end

    it 'return 403 when token has wrong issuer' do
      token = get_token :user1 do |payload|
        payload[:iss] = 'invalid_issuer.com'
      end
      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token does not have valid issuer.'
    end
  end
end
