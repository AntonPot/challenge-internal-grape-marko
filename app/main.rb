require 'grape'
require 'users'
require 'accesses'
require 'services/accessibilty'

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
        error!({error: 'Unauthorized request'}, 401)
      end

      def not_found_error!
        error!({error: 'Not found'}, 404)
      end

      def unprocessable_entity_error!(error = 'Unprocessable entity')
        error!({error: error}, 422)
      end

      def server_error!
        error!({error: 'Server error'}, 500) 
      end
    end

    rescue_from Grape::Exceptions::ValidationErrors, with: :unprocessable_entity_error!    
    rescue_from :all, with: :server_error! if ENV['RACK_ENV'] == 'production'

    mount Users
    mount Accesses
    
    desc 'Return 404 for unknown routes'
    route :any, '*path' do
      error!({ error: "Unknown route" }, 404)
    end
  end
end
