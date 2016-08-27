CollectsService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.collections_ids.each do |id|
        product.collects.create!(insales_collection_id: id)
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      destroy_missing_in_insales
      create_new_in_insales
    end
  end

  private

  def destroy_missing_in_insales
    product.collects
           .where(insales_collection_id: (current_collection_ids - insales_product.collections_ids))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.collections_ids - current_collection_ids).each do |id|
      product.collects.create!(insales_collection_id: id)
    end
  end

  def current_collection_ids
    @current_collection_ids ||= product.collects.pluck(:insales_collection_id)
  end
end
