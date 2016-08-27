CharacteristicsService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.characteristics.each do |characteristic|
        product.characteristics.create!(
          CharacteristicsMapper.new(characteristic).params
        )
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
    product.characteristics
           .where(insales_characteristics_id: (characteristic_ids - insales_product.characteristics.map(&:id)))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.characteristics.map(&:id) - characteristic_ids).each do |insales_id|
      product.characteristics.create!(
        CharacteristicsMapper.new(insales_characteristic(insales_id)).params
      )
    end
  end

  def update_intersecting
    product.characteristics
           .where(insales_characteristics_id: (insales_product.characteristics.map(&:id) & characteristic_ids))
           .each do |characteristic_in_db|
             characteristic_in_db.attributes =
               CharacteristicsMapper.new(
                 insales_characteristic(characteristic_in_db.insales_characteristics_id)
               ).params
             characteristic_in_db.save! if characteristic_in_db.changed?
           end
  end

  def characteristic_ids
    @characteristic_ids ||= product.characteristics.pluck(:insales_characteristics_id)
  end

  def insales_characteristic(id)
    insales_product.characteristics.find { |i| i.id == id }
  end
end
