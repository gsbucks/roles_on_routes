require 'rolesonroutes/base'
require 'active_support/concern'
require 'abstract_controller'

module RolesOnRoutes
  module AuthorizesFromRolesController
    extend ActiveSupport::Concern

    included do
      before_filter :authorize_from_role_intersection
    end

    private

    def current_user_roles
      begin
        super
      rescue NoMethodError => e
        raise NoMethodError, 'A controller which includes this module must define a current_user_roles method'
      end
    end

    def authorize_from_role_intersection
      return true if (Array.wrap(current_user_roles) & Array.wrap(roles_from_route)).any?
      role_authorization_failure_response
    end

    def role_authorization_failure_response
      render nothing: true, status: :unauthorized
    end

    def roles_from_route
      RolesOnRoutes::Base.roles_for(request.path, request.request_method)
    end

  end
end
