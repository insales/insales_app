class Product < ActiveRecord::Base
  validates :insales_product_id, presence: true
  belongs_to :account
  has_many :collects
  has_many :images
  has_many :option_names
  has_many :properties
  has_many :characteristics
  has_many :variants

  def to_param
    insales_product_id.to_s
  end
end
