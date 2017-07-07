require 'app/main'

module ApiHelpers
  def app
    Api::Main
  end

  def set_auth_header(token)
    auth = "Token #{token}"
    header 'Authentication', auth
  end

  def json_response
    @json ||= Hashie::Mash.new(JSON.parse(last_response.body))
  end
end
