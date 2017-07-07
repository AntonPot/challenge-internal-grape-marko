require 'grape'

module Api
  class Users < Grape::API
    get :user do
      # Your code here
    end

    resource :users do
      post do
        # Your code here
      end
    end
  end
end
