module RolesOnRoutes
  class EngineAwareRouteSet

    def self.for(app)
      new(app.routes)
    end

    def initialize(main_routeset)
      @main_routeset = main_routeset
    end

    def recognize_path(path, environment={})
      route_match = @main_routeset.router.send(:find_routes, {
        'PATH_INFO' => path,
        'REQUEST_METHOD' => environment[:method]
      }).first

      if route_match
        journey_route = route_match.last
        engine = journey_route.app

        if engine.respond_to?(:routes)
          begin
            engine_path = path.gsub(journey_route.path.to_regexp, '')
            return engine.routes.recognize_path(engine_path, environment)
          rescue ActionController::RoutingError
          end
        end
      end

      @main_routeset.recognize_path(path, environment) 
    end
  end
end
