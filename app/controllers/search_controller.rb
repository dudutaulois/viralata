Waypoint = Struct.new(:src, :dst, :point)
Travel = Struct.new(:origin, :destination, :waypoints)
class Travel
  def initialize(origin, destination)
    @origin, @destination = origin, destination
    @waypoints = []
  end
  attr_reader :origin, :destination

  def calculate
    origin.paths.each do |origin_path|
      distance = 0
      lst = origin_path
      cur = origin_path.nxt
      while cur != origin_path and cur.nxt
        distance += lst.distance_to(cur)
        other_paths = Path.joins(:points).where('points.id' = cur.point_id)
        other_paths.each do |fork_path|
          if fork_path == destination.path
            # At the destination
            
          end
        end

        lst = cur
        cur = cur.nxt
      end
    end
  end

end


class SearchController < ApplicationController
  def index
    @no_header = true
  end
  
  def destination

  end

  def path
    orig_point = Point.new(:lat => Float(params[:org_lat]), :lng => Float(params[:org_lng]))
    start_point = Point.closest(:origin => orig_point).first

    dest_point = Point.new(:lat => Float(params[:dst_lat]), :lng => Float(params[:dst_lng]))
    end_point = Point.closest(:origin => dest_point).first

    travel = Travel.new(start_point, end_point)

    start_point.
    
    
    if start_point.paths.length != 1
      raise "We don't handle multiple possible buses at one point"
    end
    
    start_path = start_point.paths.first
    
    @route = start_path.route
  end
  

#    	@users = User.all
#    	@hash = Gmaps4rails.build_markers(@users) do |user, marker|
#   	 marker.lat user.latitude
#  	 marker.lng user.longitude

#  def get_to_bus
#     dest_name = param[:destino]
#     destination = call_to_google_api_for_gps(dest_name)
#     
#     # Code to find bus path
#     # sets get_on
#     session[:path] = #
#     
#     @origin = session[:origin]
#     @destination = get_on
#     
#     # render page to get use to the bus stop
#  end
  
#  def on_bus
#     @path = session[:path]
#     
#     @alert = true if @path.length > 1
#     
#     @index = Integer(param[:id])
#     @route = @path[@index-1]   
#  end

#  def search_response  
#   @origin = [param[:lat], param[:lon]]
#   
# 	@origem = [37.792,-122.393] #params[:origem]
# 	@destino = [37.792,-122.393]
# 	
# 	get_on = Point.closest(@origem)
# 	get_off = Point.closest(@destino)
# 	
# 	get_on.route.connecting
# 	
# 	if get_on.route == get_off.route
# 	  path = [get_on.route => [get_on.gps, get_off.gps]]
# 	elsif i = get_on.route.intersections.find { |c| c.route_to == get_off.route }
#       path = [{get_on.route => [get_on.gps, i.gps]},
#       		  {get_off.route => [i.gps, get_off.gps]}
#     else
#     	raise "We don't do this"
# 	end
# 	session[:get_on] = get_on	
#  end

end
