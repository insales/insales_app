OptionValuesService = Struct.new(:insales_product, :product, :variant) do
  def create(insales_variant, variant_in_db)
    ActiveRecord::Base.transaction do
      insales_variant.option_values.each do |option_value|
        variant_in_db.option_values.create!(
          OptionValuesMapper.new(option_value).params
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
    variant.option_values
           .where(insales_option_value_id: (option_value_ids - insales_option_value_ids))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_option_value_ids - option_value_ids).each do |insales_id|
      variant.option_values.create!(
        OptionValuesMapper.new(insales_option_value(variant, insales_id)).params
      )
    end
  end

  def update_intersecting
    variant.option_values
           .where(insales_option_value_id: insales_option_value_ids & option_value_ids)
           .each do |option_value_in_db|
             option_value_in_db.attributes =
               OptionValuesMapper.new(
                 insales_option_value(
                   variant, option_value_in_db.insales_option_value_id
                 )
               ).params
             option_value_in_db.save! if option_value_in_db.changed?
           end
  end

  def option_value_ids
    @option_value_ids ||= variant.option_values.pluck(:insales_option_value_id)
  end

  def insales_option_value_ids
    @insales_option_value_ids ||= insales_variant(variant.insales_variant_id).option_values.map(&:id)
  end

  def variants
    @variants ||= insales_product.variants
  end

  def insales_variant(id)
    variants.find { |i| i.id == id }
  end

  def insales_option_value(variant, id)
    insales_variant(variant.insales_variant_id).option_values.find { |i| i.id == id }
  end
end
