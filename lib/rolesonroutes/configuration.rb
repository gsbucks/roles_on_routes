module RolesOnRoutes
  TAG_ROLES_ATTRIBUTE='allowed-roles'

  class Configuration
    def self.routeset_containing_roles
      @routeset_containing_roles ||= begin
        if defined?(Rails)
          Rails.application.routes 
        else
          raise NoMethodError, %q{If including this module without rails, there must be a routeset defined 
                                  using the setter routeset_containing_roles=}
        end
      end
    end

    def self.routeset_containing_roles=(routeset)
      @routeset_containing_roles = routeset
    end
  end
end
