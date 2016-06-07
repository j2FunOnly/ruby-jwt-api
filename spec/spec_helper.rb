# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.

ENV['RACK_ENV'] = 'test'
ENV['JWT_SECRET'] = 'testsecret'
ENV['JWT_ISSUER'] = 'testapi.com'

require 'rack/test'
require 'pry'
require 'ruby_jwt_api'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Helpers, :include_helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
