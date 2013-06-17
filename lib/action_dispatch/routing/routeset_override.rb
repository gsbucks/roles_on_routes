require 'action_dispatch'

module ActionDispatch
  module Routing
    class RouteSet
      def roles_for(path, verb = 'get')
        recognized_pathset = recognize_path(path, { method: verb })
        action = recognized_pathset[:action]
        Array.wrap(action_roles_from_path(recognized_pathset, action) || roles_from_path(recognized_pathset) || [])
      end

      private

      def action_roles_from_path(pathset, action)
        pathset[:action_roles] && pathset[:action_roles][action.to_sym]
      end

      def roles_from_path(pathset)
        pathset[:roles]
      end
    end
  end
end
