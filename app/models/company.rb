class Company < ActiveRecord::Base
  has_many :routes, -> { order :name }
end
