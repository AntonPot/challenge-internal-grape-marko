require 'grape'
require 'models/access'

module Api
  class Accesses < Grape::API
    resource :accesses do
      before { authenticate! }

      desc 'Return accesses belonging to token owner'
      get do
        { accesses: @current_user.accesses.order(:starts_at).reverse.as_json }
      end


      desc 'Create access for token owner and return it'
      params do
        requires :access, type: Hash do
          requires :level, type: Integer, desc: 'Access level'
          requires :starts_at, type: Time, desc: 'Access start point'
          requires :ends_at, type: Time, desc: 'Access end point'
        end
      end
      post do
        access = @current_user.accesses.create(params[:access])
        if access.valid?
          access.as_json(root: true)
        else
          unprocessable_entity_error!(access.errors.messages)
        end
      end


      desc 'Destroy access with provided id'
      params do
        requires :id, type: String, desc: 'Access ID.'
      end
      delete ':id' do
        access = Access.where( id: params[:id], user_id: @current_user.id )        
        unless access.empty?
          access.first.destroy
          body false
        else
          not_found_error!
        end        
      end
    end
  end
end
