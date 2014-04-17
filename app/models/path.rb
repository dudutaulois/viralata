class Path < ActiveRecord::Base
  belongs_to :point
  belongs_to :route
  
  belongs_to :nxt, class_name: 'Path', foreign_key: :next_id
  has_one :prv, class_name: 'Path', foreign_key: :next_id 

  def near_list(dist = 5)
    return @near_list if @near_list
    @near_list = Path.includes(:point).where("sequence <= ? AND sequence >= ?", sequence + dist, sequence - dist).all.to_a - [self]
  end
  
  def forward_list
    return @forward_list if @forward_list
    path_scope = Path.includes(:point => :paths).where(:route_id => route_id).order(:sequence)
    path_list_before = path_scope.where("sequence < ?", sequence)
    path_list_after = path_scope.where("sequence > ?", sequence)
    @forward_list = path_list_after + path_list_before
  end

end
