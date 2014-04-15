class SearchController < ApplicationController

  def index
    @no_header = true
  end
  
  def busroutes
  end
  
  def testcsv
  
  require 'csv'  
  
 	 	
 	@destino = Array.new
 		CSV.foreach('app/assets/Routes-Test.csv', headers:true) do |row|
 		@destino << row[2]	
  	end
  	
  	   CSV.foreach('dsfsdf', headers:true) do |row|
  	     Point.insert(latitude: row['Lat'], longitude: row['Lon'])
  	   end
  
  end

  

  
#    	@users = User.all
#    	@hash = Gmaps4rails.build_markers(@users) do |user, marker|
#   	 marker.lat user.latitude
#  	 marker.lng user.longitude




  def destination
#     origin = [param[:lat], param[:lon]]
# 
# 	session[:origin] = origin
  end
  
  
 
  def get_to_bus
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
  end
  
  def on_bus
#     @path = session[:path]
#     
#     @alert = true if @path.length > 1
#     
#     @index = Integer(param[:id])
#     @route = @path[@index-1]
    
  end

  def search_response
  
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
	
  end
 
  
#   
#   def destino(to_where)
#   	
#   	return @destino = params[:destino]
#   	
#   	end
  


end


 
