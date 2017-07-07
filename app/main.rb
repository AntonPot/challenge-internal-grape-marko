require 'grape'

require_relative 'users'
require_relative 'accesses'

module Api
  class Main < Grape::API
    mount Users
    mount Accesses
  end
end
