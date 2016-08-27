class Account < ActiveRecord::Base
  validates :insales_id, presence: true
  validates :insales_subdomain, presence: true
  validates :password, presence: true

  has_many :products

  def override_update_time(product)
    update_attributes!(updated_since: product.updated_at, last_id: product.id)
  end
end
