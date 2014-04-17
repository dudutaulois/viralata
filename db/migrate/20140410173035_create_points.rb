class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :lat
      t.float :lng
      t.timestamps
    end
        
    create_table :paths do |t|
      t.integer :point_id
      t.integer :route_id
      #t.integer :next_id
      t.integer :sequence
   	  
      t.string :street
      t.string :city
    end

    create_table :routes do |t|
      t.integer :company_id
      t.string :name

      t.string :origin
      t.string :destination

    end

    create_table :companies do |t|
      t.string :name
      t.string :direction
      t.string :phone
      t.string :email
      t.string  :route_name
      t.timestamps
    end
  end
end
