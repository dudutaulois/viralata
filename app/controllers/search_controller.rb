class Travel
  # origin - Database origin point
  # destination - Database destination point
  # waypoints - List of database path.  First is associated with origin, last with destination
  def initialize(origin, destination)
    @origin, @destination = origin, destination
    @waypoints = []
    @distance = 0.0
  end
  attr_reader :origin, :destination, :waypoints
  attr_reader :distance
  def add_distance(d)
    @distance += d
  end

  def path_traverse(from_paths = origin.paths)
    from_paths.map do |origin_path|
      # Don't go back on the same route
      next if waypoints.find { |w| w.route_id == origin_path.route_id }
      
      travel = self.dup
      travel.waypoints << origin_path

      path_forward = origin_path.forward_list

      path_pairs = path_forward[0..-2].zip(path_forward[1..-1])

      if destination.paths.find { |p| p.route_id == origin_path.route_id }
        # We are on a route that goes to the destination.
        path_pairs.each do |lst_path, cur_path|
          travel.add_distance(lst_path.point.distance_to(cur_path.point))
          if destination.paths.include?(cur_path)
            travel.waypoints << cur_path
            break
          end
        end
        next travel
      end
      
      next # Transfers not implemented yet
      path_pairs.map do |lst_path, cur_path|
        travel.distance += lst_path.distance_to(cur_path)

        # Possible transfer
        # Doesn't handle multiple equivaletent transfer points
        travel.path_traverse(cur_path.point.paths - [cur_path])
      end
    end.flatten
  end
end


class SearchController < ApplicationController
  def index
    @no_header = true
  end
  
  def destination
    @no_header = true
  end

  def point_from(lat, lng)
    orig_point = Point.new(:lat => Float(lat), :lng => Float(lng))
    points = Point.by_distance(:origin => orig_point).includes(:paths).limit(5).all.to_a

    result = [points.shift]

    # Bad way to do this, just use sequence numbers
    while points.first
      p = points.shift
      near_points = p.paths.map(&:near_list).flatten.map(&:point)
      points -= near_points
      result << p if (near_points & result).empty?
    end

    [orig_point, result]
  end

  def path
    @no_header = true

    orig_point, start_points = point_from(params[:org_lat] || -33.02919,
                                          params[:org_lng] || -71.513044)
    logger.info "Start Points:"
    start_points.each do |pt|
      logger.info "  #{pt.id}: #{pt.cord_str}"
    end

    dest_point, end_points = point_from(params[:dst_lat], params[:dst_lng])
    logger.info "End Points:"
    end_points.each do |pt|
      logger.info "  #{pt.id}: #{pt.cord_str}"
    end

    travels =
      start_points.map do |sp|
      end_points.map do |ep|
        Travel.new(sp, ep).path_traverse
      end
    end.flatten.compact.sort_by { |t| t.distance }

    best = [travels.shift]
    best += travels.find_all do |travel|
      travel.distance - best.first.distance < 0.5
    end

    best.each do |travel|
      logger.info "Distance: #{travel.distance}"
      logger.info "  Get on: #{travel.waypoints.first.point.cord_str}"
      logger.info " Get off: #{travel.waypoints.last.point.cord_str}"
      logger.info
    end
    
    logger.info("Routes: #{best.inspect}")
    best

    start_path = best.first.waypoints.first
    
    @dest_name = params[:name]
    @route = start_path.route
  end

  def busroutes
    @companies = Company.order(:service).all
  end
end
