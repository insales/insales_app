class ProductWidgetsController < ApplicationController
  def create
    InsalesApi::ApplicationWidget.all.each {|v| v.destroy }
    @current_account_id = current_account.id
    @app_host = request.host_with_port
    InsalesApi::ApplicationWidget.create(code: code, height: 100, page_type: "product")
    redirect_to root_path, notice: "Виджет для товаров в бэкофисе создан."
  end

  private

  def code
    render_to_string(
      partial: "product_widgets/product_widget",
      formats: [:html],
      layout: false,
      locals: { app_host: @app_host, current_account_id: @current_account_id }
    )
  end
end
