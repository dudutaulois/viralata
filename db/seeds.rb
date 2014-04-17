# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

files = Dir[Rails.root.join('db', 'companies').to_s + "/*.html"]
files.each do |file_name|
  puts "File: #{file_name}"
  doc = Nokogiri::HTML(open(file_name))

  /(\d{3})$/ === doc.at('title').text
  service = $1

  attrs = {}
  { :name => 'Nombre',
    :direction => 'Dirección',
    :phone => 'Fono',
    :email => 'Mail' }.each do |attr, name|
    attrs[attr] = doc.at("//td/strong[text()='#{name}:']/../text()").text.strip
  end
  
  company = Company.where(:service => service).first
  company = Company.create(attrs.merge(:service => service)) unless company

  puts "Company: #{company.service} : #{attrs.inspect}"

  doc.xpath("//div[@id='container-txt-un']/table/tr")[1..-1].each do |tr|
    attrs = {}

    list = tr.xpath('td').map(&:text).map(&:strip)
    list[2] = list[2].split('/')
    list.flatten!

    [:name, :description, :origin, :destination, :price_direct, :price_local, :price_plan].zip(list).each do |attr, value|
      attrs[attr] = value
    end

    route = Route.where(:name => attrs[:name]).first
    route = Route.create(attrs) unless route

    puts "  Route: #{attrs.inspect}"
  end
end

files = Dir[Rails.root.join('db', 'routes').to_s + "/*.csv"]
files.each do |file_name|
  /\/([^\/]+)\.csv$/ =~ file_name
  route_name = $1

  print "Route: #{route_name}: "
  
  # Database transaction must do everything or rollback everything
  Point.transaction do
    route = Route.where(:name => route_name).first
    route = Route.create(:name => route_name) unless route
		
    first_path = nil
    last_path = nil

    sequence = 0
    CSV.foreach(file_name, headers: true) do |row|
      lat = Float(row['Latitude'])
      lng = Float(row['Longitude'])
      
      point = Point.where(:lat => lat, :lng => lng).first
      point = Point.create(:lat => lat, :lng => lng) unless point
      
      path = Path.create(:route => route,
                         :point => point,
                         :street => row['Street'],
                         :city => row['City'],
                         :sequence => sequence)
      if last_path
        last_path.nxt = path
        last_path.save!
      end
      
      last_path = path						   
      first_path = path unless first_path
      sequence += 1
      print "*"
    end
    puts
    
    # Complete path loop
    last_path.nxt = first_path
    last_path.save!		
  end
end
