module RolesOnRoutes
  TAG_ROLES_ATTRIBUTE='allowed-roles'

  class Configuration
    class << self
      def routeset_containing_roles
        @routeset_containing_roles ||= begin
          if defined?(Rails)
            Rails.application.routes 
          else
            raise NoMethodError, %q{If including this module without rails, there must be a routeset defined 
                                    using the setter routeset_containing_roles=}
          end
        end
      end

      def routeset_containing_roles=(routeset)
        @routeset_containing_roles = routeset
      end

      def define_roles(&block)
        @collection = RoleCollection.new
        @collection.instance_eval &block
      end

      def role_collection
        @collection
      end
    end
  end
end
