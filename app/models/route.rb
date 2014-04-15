class Route < ActiveRecord::Base
  has_many :paths
  
  validates :name, presence: true
  validates :name, uniqueness: true
end
