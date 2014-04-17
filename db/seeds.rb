# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



files = Dir[Rails.root.join('db', 'routes').to_s + "/*.csv"]
files.each do |file_name|
  /\/([^\/]+)\.csv$/ =~ file_name
  route_name = $1

  print "Route: #{route_name}: "
  
  # Database transaction must do everything or rollback everything
  Point.transaction do
    route = Route.create(:name => route_name)
		
#    first_path = nil
#    last_path = nil

    sequence = 0
    CSV.foreach(file_name, headers: true, col_sep: "\t") do |row|
      lat = Float(row['Latitude'])
      lng = Float(row['Longitude'])
      
      point = Point.where(:lat => lat, :lng => lng).first
      point = Point.create(:lat => lat, :lng => lng) unless point
      
      path = Path.create(:route => route,
                         :point => point,
                         :street => row['Street'],
                         :city => row['City'],
                         :sequence => sequence)
#      if last_path
#        last_path.nxt = path
#        last_path.save!
#      end
      
#      last_path = path						   
#      first_path = path unless first_path
      sequence += 1
      print "*"
    end
    puts
    
    # Complete path loop
#    last_path.nxt = first_path
#    last_path.save!		
  end
end
