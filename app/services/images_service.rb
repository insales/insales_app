ImagesService = Struct.new(:insales_product, :product) do
  def create
    ActiveRecord::Base.transaction do
      insales_product.images.each do |image|
        product.images.create!(ImagesMapper.new(image).params)
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
    product.images
           .where(insales_image_id: (current_images_ids - insales_product.images.map(&:id)))
           .each(&:destroy!)
  end

  def create_new_in_insales
    (insales_product.images.map(&:id) - current_images_ids).each do |insales_id|
      product.images.create!(ImagesMapper.new(insales_image(insales_id)).params)
    end
  end

  def update_intersecting
    product.images
           .where(insales_image_id: (insales_product.images.map(&:id) & current_images_ids))
           .each do |image_in_db|
             image_in_db.attributes = ImagesMapper.new(
                                        insales_image(image_in_db.insales_image_id)).params
             image_in_db.save! if image_in_db.changed?
           end
  end

  def current_images_ids
    @current_images_ids ||= product.images.pluck(:insales_image_id)
  end

  def insales_image(id)
    insales_product.images.find { |i| i.id == id }
  end
end
