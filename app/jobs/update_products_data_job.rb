UpdateProductsDataJob = Struct.new(:current_account) do
  def perform
    UpdateProductsDataService.new(current_account).update_data
  end
end
