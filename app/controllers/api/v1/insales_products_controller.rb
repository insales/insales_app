module Api::V1
  class InsalesProductsController < ApiController
    def show
      product = Account.find(params[:account_id]).products
                       .find_by!(insales_product_id: params[:id])
      render json: { product: { id: product.id } }, status: :ok
    end
  end
end
