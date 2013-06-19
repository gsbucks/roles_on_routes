require 'roles_on_routes/configuration'
require 'roles_on_routes/dynamic_roleset'

module RolesOnRoutes
  class Base
    class << self

      def authorizes?(path, action, user_roles)
        route_roles = roles_for(path, action)
        (Array.wrap(user_roles) & route_roles).any?
      end

      def roles_for(path, verb='GET')
        path_params = Configuration.routeset_containing_roles.recognize_path(path, { method: verb })
        action = path_params[:action]
        route_roles = action_roles_from_path(path_params, action) || roles_from_path(path_params) || []
        Array.wrap(route_roles.respond_to?(:call) ? route_roles.call(path_params) : route_roles)
      end

      private

      def action_roles_from_path(pathset, action)
        return unless pathset[:action_roles].present?
        raise 'Action roles must be a hash' unless pathset[:action_roles].is_a?(Hash)
        pathset[:action_roles][action.to_sym]
      end

      def roles_from_path(pathset)
        pathset[:roles]
      end
    end
  end
end
