module RubyJWTAPI
  class JwtAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      options = {algorithm: 'HS256', iss: ENV['JWT_ISSUER']}
      bearer = env.fetch('HTTP_AUTHORIZATION', '')#.slice(7..-1)
      payload, _ = JWT.decode(bearer, ENV['JWT_SECRET'], true, options)

      env[:scopes] = payload['scopes']
      env[:user] = payload['user']

      @app.call env
    rescue JWT::DecodeError => e
      [401, {'Content-Type' => 'text/plain'}, ['A Token must be passed.' << e.to_s]]
    rescue JWT::ExpiredSignature
      [403, {'Content-Type' => 'text/plain'}, ['The token has expired.']]
    rescue JWT::InvalidIssuerError
      [
        403, {'Content-Type' => 'text/plain'},
        ['The token does not have valid issuer.']
      ]
    rescue JWT::InvalidIatError
      [
        403, {'Content-Type' => 'text/plain'},
        ['The token does not have a valid "issued at" time.']
      ]
    end
  end
end
