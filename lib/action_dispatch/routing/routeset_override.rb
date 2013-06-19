require 'action_dispatch'

module ActionDispatch
  module Routing
    class RouteSet
      def roles_for(path, verb)
        recognized_pathset = recognize_path(path, { method: verb })
        action = recognized_pathset[:action]
        action_roles_from_path(recognized_pathset, action) || roles_from_path(recognized_pathset) || []
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
