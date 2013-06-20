require 'roles_on_routes/configuration'

module RolesOnRoutes
  class DynamicRoleset
    class << self
      def add(role_reference, &block)
        @rolesets ||= {}.with_indifferent_access
        @rolesets[role_reference] = block
      end

      def execute(role_reference, params)
        raise DynamicRolesetNotFoundException, "Tried to call dynamic roleset '#{role_reference.to_s}' but there wasn't one defined. If this role is not dynamic, wrap it in an array." unless @rolesets && @rolesets[role_reference]
        @rolesets[role_reference].call(params)
      end
    end

    class DynamicRolesetNotFoundException < Exception
    end
  end
end
