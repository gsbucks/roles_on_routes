require 'rolesonroutes/configuration'

module RolesOnRoutes
  class Base
    def self.roles_for(path, action='get')
      Configuration.routeset_containing_roles.roles_for(path, action)
    end
  end
end
