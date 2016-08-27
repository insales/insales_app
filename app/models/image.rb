class Image < ActiveRecord::Base
  belongs_to :product
  validates :insales_image_id, presence: true
end
