require 'roles_on_routes/configuration'

module RolesOnRoutes
  class DynamicRoleset
    def initialize(&block)
      raise 'New dynamic rolesets must be given a block to call' unless block_given?
      @block = block
    end

    def call(*args)
      @block.call(*args)
    end

    def to_s
      '"dynamic_roleset"'
    end
    alias_method :inspect, :to_s
  end
end
