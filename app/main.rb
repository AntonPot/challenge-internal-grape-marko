require 'grape'

require_relative 'users'
require_relative 'accesses'

module Api
  class Main < Grape::API
    mount Users
    mount Accesses
    
    route :any, '*path' do
      error!({ error: "Route doesn't exist" }, 404)
    end
  end
end
