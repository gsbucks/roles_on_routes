require 'roles_on_routes/configuration'

module RolesOnRoutes
  class RoleCollection
    def initialize
      @rolesets = {}.with_indifferent_access
    end

    def add(role_reference, role_array=nil, &block)
      raise ArgumentError, 'Add must take a block or a role or a set of roles' if role_array.nil? && !block_given?
      @rolesets[role_reference] = (role_array.nil? ? block : Array.wrap(role_array))
    end

    def execute(role_reference, params)
      return [] if role_reference.blank?
      raise RolesetNotFoundException, "Tried to return roleset '#{role_reference.to_s}' but there wasn't one defined." unless @rolesets && @rolesets[role_reference]

      if @rolesets[role_reference].respond_to?(:call)
        Array.wrap(@rolesets[role_reference].call(params))
      else
        @rolesets[role_reference]
      end
    end

    def [](roleset)
      Array.wrap(@rolesets[roleset])
    end

    class RolesetNotFoundException < Exception
    end
  end
end
