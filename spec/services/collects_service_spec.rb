require 'spec_helper'

describe CollectsService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      collections_ids: [1]
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
    subject(:service) { CollectsService.new(insales_product, product)}
    it "should create collects for product" do
      service.create
      expect(Product.last.collects.count).to eq(1)
      expect(Product.last.collects.last.insales_collection_id).to eq(1)
    end
  end

  context "#update" do
    subject(:service) { CollectsService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        collections_ids: [1, 2]
      )
    end

    before :each do
      product.collects.create(insales_collection_id: 1)
      product.collects.create(insales_collection_id: 3)
    end
    it "should delete collections which are not anymore in insales" do
      expect(Product.last.collects.map(&:insales_collection_id)).to eq([1, 3])
      service.update
      expect(Product.last.collects.count).to eq(2)
      expect(Product.last.collects.map(&:insales_collection_id)).not_to include(3)
    end

    it "should create collections which were not in app" do
      service.update
      expect(Product.last.collects.map(&:insales_collection_id)).to include(2)
    end
  end
end
