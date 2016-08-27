require 'spec_helper'

describe VariantsService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      variants: [variant1]
    )
  end

  let :variant1 do
    double(
      :variant1,
      id: 1,
      quantity: 2,
      barcode: nil,
      cost_price: 100,
      old_price: 80,
      price: 90,
      sku: 1,
      created_at: "2016-05-21 14:22:17 +0300",
      updated_at: "2016-05-21 14:22:17 +0300",
      weight: 1,
      title: "new title",
      option_values: []
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
    subject(:service) { VariantsService.new(insales_product, product)}
    it "should create variants for product" do
      service.create
      expect(Product.last.variants.count).to eq(1)
      expect(Product.last.variants.last.insales_variant_id).to eq(1)
      expect(Product.last.variants.last.title).to eq("new title")
    end
  end

  context "#update" do
    subject(:service) { VariantsService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        variants: [variant1, variant2]
      )
    end

    let :variant2 do
      double(
      :variant2,
      id: 2,
      quantity: 3,
      barcode: nil,
      cost_price: 120,
      old_price: 80,
      price: 100,
      sku: 2,
      created_at: "2016-05-21 14:22:17 +0300",
      updated_at: "2016-05-21 14:22:17 +0300",
      weight: 2,
      title: "title2",
      option_values: []
      )
    end

    before :each do
      product.variants.create(insales_variant_id: 1,
                              quantity: 3,
                              barcode: nil,
                              cost_price: 120,
                              old_price: 80,
                              price: 100,
                              sku: 2,
                              created_at: "2016-05-21 14:22:17 +0300",
                              updated_at: "2016-05-21 14:22:17 +0300",
                              weight: 2,
                              title: "title1")
      product.variants.create(insales_variant_id: 3,
                              quantity: 3,
                              barcode: nil,
                              cost_price: 120,
                              old_price: 80,
                              price: 100,
                              sku: 2,
                              created_at: "2016-05-21 14:22:17 +0300",
                              updated_at: "2016-05-21 14:22:17 +0300",
                              weight: 2,
                              title: "title3")
    end

    it "should delete variants which are not anymore in insales" do
      expect(Product.last.variants.map(&:insales_variant_id)).to eq([1, 3])
      service.update
      expect(Product.last.variants.count).to eq(2)
      expect(Product.last.variants.map(&:insales_variant_id)).not_to include(3)
    end

    it "should create variants which were not in app" do
      service.update
      expect(Product.last.variants.map(&:insales_variant_id)).to include(2)
    end

    it "should update variants existing in both systems" do
      service.update
      upd_variant = Product.last.variants.find_by(insales_variant_id: 1)
      expect(upd_variant.title).to eq("new title")
    end
  end
end
