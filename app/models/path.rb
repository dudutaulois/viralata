class Path < ActiveRecord::Base
  belongs_to :point
  belongs_to :route
  
  belongs_to :nxt, class_name: 'Path', foreign_key: :next_id
  has_one :prv, class_name: 'Path', foreign_key: :next_id 

end
