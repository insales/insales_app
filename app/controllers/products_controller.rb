class ProductsController < ApplicationController
  helper_method :insales_product_url, :product

  def index
    @products = current_account.products.order(insales_updated_at: :desc)
  end

  def show
    @images = product.images.pluck(:original_url)
  end

  def update
    ProductsData.new(product_from_api).update(product)
    redirect_to product
  end

  private

  def product_from_api
    InsalesApi::Product.find(params[:id])
  end

  def insales_product_url
    "http://#{current_account.insales_subdomain}/admin2/products/#{product.insales_product_id}"
  end

  def product
    @product ||= current_account.products.find_by_insales_product_id(params[:id])
  end
end
