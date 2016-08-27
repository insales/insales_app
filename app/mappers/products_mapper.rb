ProductsMapper = Struct.new(:insales_product) do
  def params
    {
      archived: insales_product.archived,
      available: insales_product.available,
      canonical_url_collection_id: insales_product.canonical_url_collection_id,
      category_id: insales_product.category_id,
      insales_created_at: insales_product.created_at,
      is_hidden: insales_product.is_hidden,
      sort_weight: insales_product.sort_weight,
      unit: insales_product.unit,
      short_description: insales_product.short_description,
      permalink: insales_product.permalink,
      html_title: insales_product.html_title,
      meta_keywords: insales_product.meta_keywords,
      meta_description: insales_product.meta_description,
      currency_code: insales_product.currency_code,
      description: insales_product.description,
      title: insales_product.title,
      insales_product_id: insales_product.id,
      insales_updated_at: insales_product.updated_at
    }
  end
end
