VariantsService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.variants.each do |insales_variant|
        variant_in_db = product.variants.create!(VariantsMapper.new(insales_variant).params)
        OptionValuesService.new(insales_product, product).create(insales_variant, variant_in_db)
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      destroy_missing_in_insales
      create_new_in_insales
      update_intersecting
    end
  end

  private

  def destroy_missing_in_insales
    product.variants
           .where(insales_variant_id: (variant_ids - insales_product.variants.map(&:id)))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.variants.map(&:id) - variant_ids).each do |insales_id|
      product.variants.create!(VariantsMapper.new(insales_variant(insales_id)).params)
    end
  end

  def update_intersecting
    product.variants
           .where(insales_variant_id: (insales_product.variants.map(&:id) & variant_ids))
           .each do |variant_in_db|
             variant_in_db.attributes = 
               VariantsMapper.new(
                 insales_variant(variant_in_db.insales_variant_id)
               ).params
             variant_in_db.save! if variant_in_db.changed?
           end
  end

  def variant_ids
    @variant_ids ||= product.variants.pluck(:insales_variant_id)
  end

  def insales_variant(id)
    insales_product.variants.find { |i| i.id == id }
  end
end
