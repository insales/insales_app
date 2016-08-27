class UpdateProductsDataService
  attr_accessor :current_account, :current_app, :products_from_db

  def initialize(current_account)
    self.current_account = current_account
    self.current_app = MyApp.new(current_account.insales_subdomain, current_account.password)
    self.products_from_db = current_account.products
  end

  def update_data
    current_app.configure_api
    InsalesApi::Product.find_updated_since(
      current_account.updated_since,
      from_id: current_account.last_id
    ) do |items|
      save_or_update_in_local_db(items.elements)
      current_account.override_update_time(items.elements.last)
    end
  end

  private

  def save_or_update_in_local_db(insales_products)
    products = products_from_db.where(insales_product_id: insales_products.map(&:id))
                               .index_by(&:insales_product_id)
    insales_products.each do |insales_product|
      if (product = products[insales_product.id])
        ProductsData.new(insales_product).update(product)
      else
        ProductsData.new(insales_product).create(current_account)
      end
    end
  end
end
