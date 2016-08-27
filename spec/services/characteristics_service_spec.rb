require 'spec_helper'

describe CharacteristicsService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      characteristics:              [characteristic1]
    )
  end

  let :characteristic1 do
    double(
      :characteristic1,
      id: 7,
      position: 1,
      property_id: 9,
      title: "Nike",
      permalink: "nike"
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
    subject(:service) { CharacteristicsService.new(insales_product, product)}
    it "should create characteristics for product" do
      service.create
      expect(Product.last.characteristics.count).to eq(1)
      expect(Product.last.characteristics.last.insales_characteristics_id).to eq(7)
      expect(Product.last.characteristics.last.insales_property_id).to eq(9)
    end
  end

  context "#update" do
    subject(:service) { CharacteristicsService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        characteristics: [characteristic1, characteristic2]
      )
    end

    let :characteristic2 do
      double(
        :characteristic2,
        id: 8,
        position: 2,
        property_id: 9,
        title: "Adidas",
        permalink: "adidas"
      )
    end

    before :each do
      product.characteristics.create(insales_characteristics_id: 7,
                                     position: 1,
                                     insales_property_id: 9,
                                     title: "Mike",
                                     permalink: "mike")
      product.characteristics.create(insales_characteristics_id: 9,
                                     position: 3,
                                     insales_property_id: 9,
                                     title: "Inrelevant",
                                     permalink: "inrelevant")
    end
    it "should delete characteristics which are not anymore in insales" do
      expect(Product.last.characteristics.map(&:insales_characteristics_id)).to eq([7, 8])
      service.update
      expect(Product.last.characteristics.count).to eq(2)
      expect(Product.last.characteristics.map(&:insales_characteristics_id)).not_to include(9)
    end

    it "should create characteristics which were not in app" do
      service.update
      expect(Product.last.characteristics.map(&:insales_characteristics_id)).to include(8)
    end

    it "should update characteristics existing in both systems" do
      service.update
      upd_charachteristic = Product.last.characteristics.find_by(insales_characteristics_id: 7)
      expect(upd_charachteristic.title).to eq("Nike")
      expect(upd_charachteristic.permalink).to eq("nike")
    end
  end
end
