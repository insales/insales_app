VariantsMapper = Struct.new(:variant) do
  def params
    {
      insales_variant_id: variant.id,
      title: variant.title,
      quantity: variant.quantity,
      barcode: variant.barcode,
      cost_price: variant.cost_price,
      old_price: variant.old_price,
      price: variant.price,
      sku: variant.sku,
      insales_created_at: variant.created_at,
      insales_updated_at: variant.updated_at,
      weight: variant.weight
    }
  end
end
