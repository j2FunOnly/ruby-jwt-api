RSpec.describe RubyJWTAPI::Api do
  let(:app) { described_class }

  describe 'with valid token' do
    it 'return money amount for autheticated user' do
      login = Rack::Test::Session.new(Rack::MockSession.new(RubyJWTAPI::Public))
      login.post '/login', username: 'user1', password: 'password1'
      res = login.last_response
      expect(res).to be_ok
      token = JSON.parse(login.last_response.body)['token']

      get '/money', {}, {'HTTP_AUTHORIZATION' => token}
      expect(last_response.status).to eq 200
      expect(last_response.body).to match 'money'
    end
  end
end
