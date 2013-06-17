require 'action_dispatch'
require 'active_support/core_ext'
require 'active_support/dependencies'

module ActionDispatch
  module Routing
    class Mapper
      module ClearsActionRolesFromChildScope
        def resources(*resources, &block)
          super(*resources) do
            cleared_action_roles = @scope[:options].delete(:action_roles)
            yield if block_given?
            @scope[:options][:action_roles] = cleared_action_roles if cleared_action_roles.present?
          end
        end
      end

      include ClearsActionRolesFromChildScope
    end
  end
end
