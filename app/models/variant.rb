class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :option_values
  validates :insales_variant_id, presence: true
end
