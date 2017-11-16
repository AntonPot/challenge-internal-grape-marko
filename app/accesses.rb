require 'grape'
require 'models/access'

module Api
  class Accesses < Grape::API
    resource 'accesses' do

      desc 'Return accesses belonging to token owner'
      get do
        authenticate!
        JSONFormatter.for_accesses @current_user.accesses.order(:starts_at)
      end

      desc 'Create access for token owner and return it'
      params do
        requires :access, type: Hash do
          requires :level, type: Integer, desc: 'Access level'
          requires :starts_at, type: DateTime, desc: 'Access start point'
          requires :ends_at, type: DateTime, desc: 'Access end point'
        end
      end
      post do
        authenticate!
        access = @current_user.accesses.create(params[:access])
        if access.valid?
          { access: JSONFormatter.for_access(access) }
        else
          validations_error!(access.errors.messages)
        end
      end

      desc 'Destroy access with provided id'
      params do
        requires :id, type: String, desc: 'Access ID.'
      end
      delete ':id' do
        authenticate!
        access = Access.where( id: params[:id], user_id: @current_user.id )        
        unless access.empty?
          access.first.destroy
          body false
        else
          unprocessable_entity_error!
        end        
      end
    end
  end
end
