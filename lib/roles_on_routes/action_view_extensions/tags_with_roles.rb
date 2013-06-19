require 'roles_on_routes/base'
require 'action_dispatch/routing/routeset_override'
require 'action_dispatch/routing/mapper_override'
require 'action_view'
require 'action_controller'

module RolesOnRoutes
  module ActionViewExtensions
    module TagsWithRoles
      def link_to_with_roles(link_text, poly_array, options={})
        link_to link_text, poly_array, options.merge({ RolesOnRoutes::TAG_ROLES_ATTRIBUTE => roles_from_polymorphic_array(poly_array).join(' ') })
      end

      def div_with_roles(roles, options={}, &block)
        raise 'Must provide a block to div_with_roles' unless block_given?
        content_tag(:div, options.merge({ RolesOnRoutes::TAG_ROLES_ATTRIBUTE => Array.wrap(roles).join(' ') }), &block)
      end

    private

      def roles_from_polymorphic_array(array)
        RolesOnRoutes::Base.roles_for(url_for(array))
      end
    end
  end
end

ActionView::Base.send :include, RolesOnRoutes::ActionViewExtensions::TagsWithRoles
