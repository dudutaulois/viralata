class Point < ActiveRecord::Base
  acts_as_mappable
  has_many :paths
end
