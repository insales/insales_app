require 'spec_helper'

describe OptionValuesService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      variants: [variant]
    )
  end

  let :option_value1 do
    double(
      :option_value1,
      id: 1,
      option_name_id: 1,
      position: 1,
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

  let(:variant_in_db) do
    v = product.variants.new(
      insales_variant_id: 1,
      title: "title",
      quantity: 2,
      barcode: nil,
      cost_price: 100,
      old_price: 90,
      price: 110,
      sku: 1,
      insales_created_at: "2016-05-20 14:22:17 +0300",
      insales_updated_at: "2016-05-20 14:22:17 +0300",
      weight: 1
    )
    v.save
    v
  end

  let :variant do
    double(
      :variant,
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
      option_values: [option_value1]
    )
  end

  context "#create" do
    subject(:service) { OptionValuesService.new(insales_product, product)}
    it "should create option_values for product" do
      service.create(variant, variant_in_db)
      expect(Variant.last.option_values.count).to eq(1)
      expect(Variant.last.option_values.last.insales_option_id).to eq(1)
      expect(Variant.last.option_values.last.title).to eq("new title")
    end
  end

  context "#update" do
    subject(:service) { OptionValuesService.new(insales_product1, product, variant_in_db)}

    let :insales_product1 do
      double(
        :insales_product1,
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
        option_values: [option_value1, option_value2]
      )
    end

    let :option_value2 do
      double(
        :option_value2,
        id: 2,
        option_name_id: 1,
        position: 2,
        title: "title2"
      )
    end

    before :each do
      variant_in_db.option_values.create(insales_option_value_id: 1,
                                        insales_option_id: 1,
                                        position: 2,
                                        title: "title1")
      variant_in_db.option_values.create(insales_option_value_id: 3,
                                         insales_option_id: 1,
                                         position: 2,
                                         title: "title3")
    end
    it "should delete option_values which are not anymore in insales" do
      expect(Variant.last.option_values.map(&:insales_option_value_id)).to eq([1, 3])
      service.update
      expect(Variant.last.option_values.count).to eq(2)
      expect(Variant.last.option_values.map(&:insales_option_value_id)).not_to include(3)
    end

    it "should create option_values which were not in app" do
      service.update
      expect(Variant.last.option_values.map(&:insales_option_value_id)).to include(2)
    end

    it "should update option_values existing in both systems" do
      service.update
      upd_option_value = Variant.last.option_values.find_by(insales_option_value_id: 1)
      expect(upd_option_value.title).to eq("new title")
    end
  end
end
