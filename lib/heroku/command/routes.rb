module Heroku::Command

  # manage routes
  class Routes < BaseWithApp

    # routes
    #
    # show routes and associated processes
    #
    def index
      routes = heroku.routes(app)
      output = []
      hdr1_width = 10
      hdr2_width = 10
      routes.each do |route|
        hdr1_width = route["url"].length if route["url"].length > hdr1_width
        hdr2_width = route["ps"].length if route["ps"].length > hdr2_width
        output << "%-28s  %-12s" % [route["url"], route["ps"]]
      end
      display("Route".ljust(hdr1_width) + "  Process".ljust(hdr2_width))
      display(('-' * hdr1_width) + "  " + ('-' * hdr2_width))
      display(output.join("\n"))
    end

    # routes:create
    #
    # create a new route
    #
    def create
      display("Creating route... ", false)
      proto = nil
      case args.shift
        when "--proto"
          proto = args.shift
      end
      route = heroku.routes_create(app, proto)
      display("done")
      display(route["url"])
    end

    # routes:attach ROUTE PROCESS
    #
    # attach a process to a route
    #
    def attach
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:attach ROUTE PROCESS")
      display("Attaching route #{url} to #{ps}... ", false)
      heroku.route_attach(app, url, ps)
      display("done")
    end

    # routes:detach ROUTE PROCESS
    #
    # detach a process from a route
    #
    def detach
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:detach ROUTE PROCESS")
      display("Detaching route #{url} from #{ps}... ", false)
      heroku.route_detach(app, url, ps)
      display("done")
    end

    # routes:destroy ROUTE
    #
    # destroy a route
    #
    def destroy
      route_id = args.shift || abort("Usage: heroku routes:destroy ROUTE")
      display("Destroying route #{route_id}... ", false)
      heroku.route_destroy(app, route_id)
      display("done")
    end
  end
end
