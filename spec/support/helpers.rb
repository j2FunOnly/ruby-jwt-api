module Helpers
  def get_token(username)
    payload = get_payload(username)
    yield payload if block_given?
    'Basic ' << JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
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
end
