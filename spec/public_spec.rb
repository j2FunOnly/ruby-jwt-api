ENV['JWT_SECRET'] = 'test'
ENV['JWT_ISSUER'] = 'testapi.com'

require 'rack/test'
require 'ruby_jwt_api'

include Rack::Test::Methods

RSpec.describe RubyJWTAPI::Public do
  let(:app) { described_class }

  describe 'post with valid data' do
    it 'return token' do
      post '/login', username: 'user1', password: 'password1'
      expect(last_response).to be_ok
      res = JSON.parse(last_response.body)
      expect(res).to have_key 'token'
    end
  end

  describe 'post with invalid data' do
    it 'return 401 code' do
      post '/login', username: 'hacker', password: 'pA$$w0rd'
      expect(last_response.status).to eq 401
    end
  end
end
