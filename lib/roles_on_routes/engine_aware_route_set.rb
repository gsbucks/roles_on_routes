module RolesOnRoutes
  class EngineAwareRouteSet

    def self.for(app)
      engines = app.railties.engines
      new(app.routes, engines) 
    end

    def initialize(main_routeset, engines=[])
      @main_routeset = main_routeset
      @engines = engines
    end

    def recognize_path(path, environment={})
      @engines.each do |engine|
        # Find "mount" for the engine via named_routes on main_routeset
        mount_route = @main_routeset.named_routes.routes.values.find { |r| r.app.to_s == engine.class.to_s }
        next unless mount_route

        engine_path = path.gsub(%r(^#{mount_route.path.spec.to_s}), '')
        begin
          return engine.routes.recognize_path(engine_path, environment)
        rescue ActionController::RoutingError
        end
      end

      @main_routeset.recognize_path(path, environment) 
    end
  end
end
