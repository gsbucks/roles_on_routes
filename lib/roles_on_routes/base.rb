require 'roles_on_routes/configuration'
require 'roles_on_routes/dynamic_roleset'

module RolesOnRoutes
  class Base
    class << self

      def authorizes?(path, action, user_roles, params = {})
        route_roles = roles_for(path, action, params)
        (Array.wrap(user_roles) & route_roles).any?
      end

      def roles_for(path, action='GET', params={})
        route_roles = Configuration.routeset_containing_roles.roles_for(path, action)
        Array.wrap(route_roles.respond_to?(:call) ? route_roles.call(params) : route_roles)
      end

    end
  end
end
