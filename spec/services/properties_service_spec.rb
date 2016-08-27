require 'spec_helper'

describe PropertiesService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      properties: [property1]
    )
  end

  let :property1 do
    double(
      :property1,
      id: 1,
      backoffice: false,
      is_hidden: true,
      is_navigational: true,
      position: 1,
      permalink: "property1",
      title: "new title"
    )
  end

  let(:product) do
    product = default_account.products.new(
      archived:                     false,
      available:                    true,
      canonical_url_collection_id:  "",
      category_id:                  1,
      insales_created_at:           "2016-05-21 14:22:17 +0300",
      is_hidden:                    false,
      sort_weight:                  nil,
      unit:                         "pce",
      short_description:            "",
      permalink:                    "",
      html_title:                   "",
      meta_keywords:                "",
      meta_description:             "",
      currency_code:                "",
      description:                  "",
      title:                        "product",
      insales_product_id:            1,
      insales_updated_at:           "2016-05-20 14:22:17 +0300"
    )
    product.save
    product
  end

  context "#create" do
    subject(:service) { PropertiesService.new(insales_product, product)}
    it "should create properties for product" do
      service.create
      expect(Product.last.properties.count).to eq(1)
      expect(Product.last.properties.last.insales_property_id).to eq(1)
      expect(Product.last.properties.last.title).to eq("new title")
    end
  end

  context "#update" do
    subject(:service) { PropertiesService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        properties: [property1, property2]
      )
    end

    let :property2 do
      double(
        :property2,
        id: 2,
        backoffice: false,
        is_hidden: true,
        is_navigational: true,
        position: 2,
        permalink: "property2",
        title: "title2"
      )
    end

    before :each do
      product.properties.create(insales_property_id: 1,
                                backoffice: false,
                                is_hidden: true,
                                is_navigational: true,
                                position: 1,
                                permalink: "property1",
                                title: "title1")
      product.properties.create(insales_property_id: 3,
                                backoffice: false,
                                is_hidden: true,
                                is_navigational: true,
                                position: 2,
                                permalink: "property3",
                                title: "title3")
    end
    it "should delete properties which are not anymore in insales" do
      expect(Product.last.properties.map(&:insales_property_id)).to eq([1, 3])
      service.update
      expect(Product.last.properties.count).to eq(2)
      expect(Product.last.properties.map(&:insales_property_id)).not_to include(3)
    end

    it "should create properties which were not in app" do
      service.update
      expect(Product.last.properties.map(&:insales_property_id)).to include(2)
    end

    it "should update properties existing in both systems" do
      service.update
      upd_property = Product.last.properties.find_by(insales_property_id: 1)
      expect(upd_property.title).to eq("new title")
    end
  end
end
