require 'rolesonroutes/configuration'

module RolesOnRoutes
  class Base
    class << self

      def authorizes?(path, action, user_roles)
        route_roles = roles_for(path, action)
        (Array.wrap(user_roles) & Array.wrap(route_roles)).any?
      end

      def roles_for(path, action='get')
        Configuration.routeset_containing_roles.roles_for(path, action)
      end

    end
  end
end
