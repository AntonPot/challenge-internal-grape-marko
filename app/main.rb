require 'grape'
require 'users'
require 'accesses'
require 'helpers'

module Api
  class Main < Grape::API
    format :json
    
    helpers do
      def authenticate!
        unauthorized_error! unless headers["Authentication"].is_a? String
        user = User.find_by(token: headers["Authentication"][-32..-1])        
        @current_user = user ? user : unauthorized_error!
      end

      def unauthorized_error!
        error!({error: 'Unauthorized'}, 401)
      end

      def validations_error!(error)
        error!({error: error}, 400)
      end

      def unprocessable_entity_error!
        error!({error: 'Unprocessable entity'}, 422)
      end

      def server_error!(error)
        error!({error: 'Server error'}, 500) 
      end
    end

    # rescue_from :all, with: :server_error!
    rescue_from Grape::Exceptions::ValidationErrors, with: :validations_error!    

    mount Users
    mount Accesses
    
    desc 'Return 404 for unknown routes'
    route :any, '*path' do
      error!({ error: "Unknown route" }, 404)
    end
  end
end
