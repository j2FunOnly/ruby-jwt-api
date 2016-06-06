ENV['JWT_SECRET'] = 'test'
ENV['JWT_ISSUER'] = 'testapi.com'

require 'rack/test'
require 'ruby_jwt_api'

include Rack::Test::Methods

RSpec.describe RubyJWTAPI::Api do
  let(:app) { described_class }

  describe 'with valid token' do
    it 'return money amount for autheticated user' do
      get '/money', {}, {'Authorization' => @token}
      expect(last_response.status).to eq 200
    end
  end
end
