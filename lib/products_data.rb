class ProductsData
  attr_accessor :insales_product, :product

  def initialize(insales_product)
    self.insales_product = insales_product
  end

  def create(account)
    ActiveRecord::Base.transaction do
      self.product = account.products.create!(ProductsMapper.new(insales_product).params)
      create_collects
      create_images
      create_option_names
      create_properties
      create_characteristics
      create_variants
    end
  end

  def update(product)
    ActiveRecord::Base.transaction do
      self.product = product
      product.attributes = ProductsMapper.new(insales_product).params
      product.save! if product.changed?
      collects_update
      images_update
      option_names_update
      properties_update
      characteristics_update
      variants_update
      option_values_update
    end
  end

  private

  def create_collects
    CollectsService.new(insales_product, product).create
  end

  def create_images
    ImagesService.new(insales_product, product).create
  end

  def create_option_names
    OptionNamesService.new(insales_product, product).create
  end

  def create_properties
    PropertiesService.new(insales_product, product).create
  end

  def create_characteristics
    CharacteristicsService.new(insales_product, product).create
  end

  def create_variants
    VariantsService.new(insales_product, product).create
  end

  def collects_update
    CollectsService.new(insales_product, product).update
  end

  def images_update
    ImagesService.new(insales_product, product).update
  end

  def option_names_update
    OptionNamesService.new(insales_product, product).update
  end

  def properties_update
    PropertiesService.new(insales_product, product).update
  end

  def characteristics_update
    CharacteristicsService.new(insales_product, product).update
  end

  def variants_update
    VariantsService.new(insales_product, product).update
  end

  def option_values_update
    product.variants.each do |variant|
      OptionValuesService.new(insales_product, product, variant).update
    end
  end
end
