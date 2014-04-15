class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :lat
      t.float :lng
      t.timestamps
    end
    
    create_table :routes do |t|
      t.string :name
    end
    
   	create_table :paths do |t|
   	  t.integer :point_id
   	  t.integer :route_id
   	  t.integer :next_id
   	  
   	  t.string :street
   	  t.string :city
   	end
  end
end
