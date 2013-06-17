require 'active_support/concern'

module RolesOnRoutes
  module AuthorizesFromRolesController
    extend ActiveSupport::Concern

    included do
      before_filter :authorize_from_role_intersection
    end

    def current_user_roles
    end

    private

    def authorize_from_role_intersection
      (Array.wrap(current_user_roles) & Array.wrap(1))
    end

    def roles_from_route
      RolesOnRoutes::Configuration.routeset_containing_roles.roles_for(request.path, request.verb)
    end

  end
end
