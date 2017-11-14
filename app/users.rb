require 'grape'
require 'models/user'

module Formater
  def self.for_user(user)
    {
      user: {
        id: user.id,
        token: user.token,
        access_level: user.access_level
      }
    }
  end
end


module Api
  class Users < Grape::API
    format :json
    
    helpers do
      def unauthorized_error!
        error!({error: 'Unauthorized'}, 401)
      end

      def server_error!(error)
        # TODO => remove message string for production
        error!({error: 'Server error', message: error.message}, 500) 
      end
    end
  
    rescue_from :all, with: :server_error!

    resource :user do
      desc 'Authenticate, set access_level and return User'
      get do
        unauthorized_error! unless headers["Authentication"].is_a? String
        user = User.find_by(token: headers["Authentication"][-32..-1])
        
        if user
          user.access_level += 1
          user.save          
          Formater.for_user(user)        
        else
          unauthorized_error!
        end
      end
    end

    resource :users do
      desc 'Create a User and return it'
      post do
        Formater.for_user(User.create)
      end
    end
  end
end

