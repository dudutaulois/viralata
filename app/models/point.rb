class Point < ActiveRecord::Base
  acts_as_mappable default_units: :kms
  has_many :paths

  def cord_str
    "#{lat},#{lng}"
  end
end
