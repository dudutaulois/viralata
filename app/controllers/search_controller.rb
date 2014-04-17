Waypoint = Struct.new(:src, :dst, :point)
Travel = Struct.new(:origin, :destination, :waypoints)
class Travel
  def initialize(origin, destination)
    @origin, @destination = origin, destination
    @waypoints = []
    @distance = 0.0
  end
  attr_reader :origin, :destination
  attr_writer :distance

  def path_traverse(from_paths = origin.paths)
    from_paths.map do |origin_path|
      # Don't go back on the same route
      next if waypoints.find { |w| w.route_id == origin_path.route_id }
      
      travel = self.dup
      travel.waypoints << origin_path

      # The :paths part of include ideally should only include paths that are not from the first Path
      path_scope = Path.includes(:point => :paths).where(:route_id => origin_path.route_id).order(:sequence)
      path_list_before = path_scope.where("sequence < ?", origin_path.sequence)
      path_list_after = path_scope.where("sequence > ?", origin_path.sequence)
      path_forward = path_list_after + path_list_before

      path_pairs = path_forward[0..-2].zip(path_forward[1..-1])

      if destination.paths.find { |p| p.route_id == origin_path.route_id }
        # We are on a route that goes to the destination.
        path_pairs.each do |lst_path, cur_path|
          travel.distance += lst_path.distance_to(cur_path)
          break if cur_path == destination.path
        end
        next travel
      end
      
      next # Transfers not implemented yet
      path_pairs.map do |lst_path, cur_path|
        travel.distance += lst_path.distance_to(cur_path)

        # Possible transfer
        # Doesn't handle multiple equivaletent transfer points
        path_traverse(cur_path.point.paths - [cur_path])
      end
    end.flatten
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

    options = travel.path_traverse.sort_by { |t| t.distance }
    
    
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
