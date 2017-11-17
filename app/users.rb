require 'grape'
require 'models/user'

module Api  
  class Users < Grape::API
    resource :user do

      desc 'Authenticate, set access_level and return User'
      get do
        authenticate!
        
        # Find user accesses that are currently active and get the one with highest level
        highest_active_access = @current_user.accesses.order(:level).map { |access|
          access if (access.starts_at < Time.now) && (Time.now < access.ends_at)
        }.last       
        
        # Set user_access if there is an active one, else set it to zero
        @current_user.access_level = highest_active_access ? highest_active_access.level : 0 
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

