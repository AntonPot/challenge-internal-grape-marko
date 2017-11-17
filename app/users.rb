require 'grape'
require 'models/user'

module Api  
  class Users < Grape::API
    resource :user do

      desc 'Authenticate, set access_level and return User'
      get do
        authenticate!
        access = Accessibilty.check_for @current_user
        @current_user.access_level = access ? access.level : 0 
        @current_user.save          
        @current_user.as_json
      end
    end

    resource :users do

      desc 'Create a User and return it'
      post do
        User.create.as_json
      end
    end
  end
end

