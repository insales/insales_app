class Characteristic < ActiveRecord::Base
  validates :insales_characteristics_id, presence: true
  belongs_to :product
end
