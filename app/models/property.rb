class Property < ActiveRecord::Base
  belongs_to :product
  validates :insales_property_id, presence: true
end
