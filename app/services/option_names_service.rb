OptionNamesService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.option_names.each do |option_name|
        product.option_names.create!(OptionNamesMapper.new(option_name).params)
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
    product.option_names
           .where(insales_option_id: (option_ids - insales_product.option_names.map(&:id)))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.option_names.map(&:id) - option_ids).each do |insales_id|
      product.option_names.create!(
        OptionNamesMapper.new(insales_option_name(insales_id)).params
      )
    end
  end

  def update_intersecting
    product.option_names
           .where(insales_option_id: (insales_product.option_names.map(&:id) & option_ids))
           .each do |option_name_in_db|
             option_name_in_db.attributes = 
               OptionNamesMapper.new(
                 insales_option_name(option_name_in_db.insales_option_id)
               ).params
             option_name_in_db.save! if option_name_in_db.changed?
           end
  end

  def option_ids
    @option_ids ||= product.option_names.pluck(:insales_option_id)
  end

  def insales_option_name(id)
    insales_product.option_names.find { |i| i.id == id }
  end
end
