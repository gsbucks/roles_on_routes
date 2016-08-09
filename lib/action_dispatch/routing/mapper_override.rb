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

      module MappingWithoutRoles
        ROLE_KEYS = [:action_roles, :roles]

        def constraints(*args)
          super(*args).tap do |cs|
            next unless cs[:required_defaults]
            cs[:required_defaults].delete_if{|set| ROLE_KEYS.include?(set[0]) }
          end
        end
      end
      Mapping.send(:prepend, MappingWithoutRoles)
    end
  end
end
