class ProductsDataController < ApplicationController
  def update
    Delayed::Job.enqueue UpdateProductsDataJob.new(current_account)
    redirect_to products_path, notice: "Обновление данных о товарах из Insales запущено."
  end
end
