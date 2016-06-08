module Helpers
  def get_token(username)
    payload = get_payload(username)
    yield payload if block_given?
    'Basic ' << JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end

  def get_payload(username)
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

  def get_amount(response)
    JSON.parse(response.body)['money'].to_i
  end
end
