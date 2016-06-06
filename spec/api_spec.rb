RSpec.describe RubyJWTAPI::Api do
  let(:app) { described_class }

  describe 'with valid token' do
    it 'return money amount for autheticated user' do
      login = Rack::Test::Session.new(Rack::MockSession.new(RubyJWTAPI::Public))
      login.post '/login', username: 'user1', password: 'password1'
      res = login.last_response
      expect(res).to be_ok
      token = 'Bearer '
      token << JSON.parse(login.last_response.body)['token']
      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 200
      expect(last_response.body).to match 'money'
    end
  end

  describe 'with invalid token' do
    it 'when no valid token present' do
      get '/money', {}, {'HTTP_AUTHORIZATION' => 'qwerty'}
      expect(last_response.status).to eq 401
      expect(last_response.body).to eq 'A Token must be passed.'
    end

    it 'when expired' do
      payload = get_payload :user1
      payload[:exp] = Time.now.to_i - 60 * 60
      token = 'Bearer ' << get_token(payload)
      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token has expired.'
    end

    it 'when wrong iat' do
      payload = get_payload :user1
      payload[:iat] = Time.now.to_i + 60 * 60 * 100
      token = 'Bearer ' << get_token(payload)

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token does not have a valid "issued at" time.'
    end

    it 'when wrong issuer' do
      payload = get_payload :user1
      payload[:iss] = 'wrong_issuer.com'
      token = 'Bearer ' << get_token(payload)

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq 'The token does not have valid issuer.'
    end
  end
end

def get_token(payload)
  JWT.encode payload, ENV['JWT_SECRET'], 'HS256'
end

def get_payload(username)
  {
    exp: Time.now.to_i + 60 * 60,
    iat: Time.now.to_i,
    iss: ENV['JWT_ISSUER'],
    scopes: ['add_money', 'remove_money', 'view_money'],
    user: {
      username: username
    }
  }
end
