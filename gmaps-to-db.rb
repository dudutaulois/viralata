require 'csv'
#require File.dirname(__FILE__) + '/config/environment'

def display_row(list)
  street, city, lat, lng = list
  puts "#{'%-25s'%street} #{'%-20s'%city} #{'%0.6f'%lat} #{'%0.6f'%lng}"
end


def display_head
  puts "Street                    City                 Latitude   Longitude"
end

CSV_HEADER = %w(Street City Latitude Longitude)

print "Route Name: "
route = gets.strip

puts
path = File.join(File.dirname(__FILE__), 'db', 'routes', "#{route}.csv")
if File.exists?(path)
  puts "File Exists:"
  display_head
  CSV.foreach(path, headers: true) do |row|
    raise "Unexpected header" unless row.to_hash.keys == CSV_HEADER
    display_row(row.to_hash.values)
  end
  csv = CSV.open(path, "ab")
else
  csv = CSV.open(path, "wb")
  csv << CSV_HEADER
end

while true
  puts

  name_list = []
  while true
    print "Street (blank to end): "
    street = gets.strip
    break if street.empty?
    
    print "Locale (blank for last): "
    locale = gets.strip
    lacale = name_list.last[1] if locale.empty?
    
    name_list << [street, locale]
  end
  
  while true
    print "Enter GMAP URL: "
    url = gets
    
    break if /\/dir\/(.+?\/)@/ === url
    puts "UNKNOWN URL"
  end
  
  point_list = $1.scan(/(?:(-\d{2}\.\d{3,8}),(-\d{2}\.\d{3,8})\/)/)
  
  if point_list.length != name_list.length
    puts "!!! LIST LENGTH MISMATCH !!!"
  end
  
  data = point_list.zip(name_list).collect do |(lat, lng), (street, locale)|
    [street, locale, lat, lng]
  end
  
  puts
  display_head
  data.each do |row|
    display_row(row)
    csv << row
  end
end


csv.close
