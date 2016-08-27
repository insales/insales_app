PropertiesService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.properties.each do |property|
        product.properties.create!(PropertiesMapper.new(property).params)
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
    product.properties
           .where(insales_property_id: (property_ids - insales_product.properties.map(&:id)))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.properties.map(&:id) - property_ids).each do |insales_id|
      product.properties.create!(
        PropertiesMapper.new(insales_property(insales_id)).params
      )
    end
  end

  def update_intersecting
    product.properties
           .where(insales_property_id: (insales_product.properties.map(&:id) & property_ids))
           .each do |property_in_db|
             property_in_db.attributes = 
               PropertiesMapper.new(
                 insales_property(property_in_db.insales_property_id)
               ).params
             property_in_db.save! if property_in_db.changed?
           end
  end

  def property_ids
    @property_ids ||= product.properties.pluck(:insales_property_id)
  end

  def insales_property(id)
    insales_product.properties.find { |i| i.id == id }
  end
end
