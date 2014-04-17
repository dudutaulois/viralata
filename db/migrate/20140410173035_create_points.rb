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
      t.integer :next_id
      t.integer :sequence
   	  
      t.string :street
      t.string :city
    end

    create_table :routes do |t|
      t.integer :company_id
      t.string :name
      t.text   :description

      t.string :origin
      t.string :destination

      t.float :price_direct
      t.float :price_local
      t.float :price_plan

    end

    create_table :companies do |t|
      t.string :name
      t.string :direction
      t.string :phone
      t.string :email
      t.string  :service
      t.timestamps
    end
  end
end
