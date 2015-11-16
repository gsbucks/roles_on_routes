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
            self
          end
        end
      end
      include ClearsActionRolesFromChildScope

      class Mapping
        
        def constraints_with_remove_roles(*args)
          constraints = constraints_without_remove_roles(*args)
          @conditions[:required_defaults].delete(:action_roles)
          @conditions[:required_defaults].delete(:roles)
          constraints
        end
        alias_method_chain :constraints, :remove_roles
      end
    end
  end
end
