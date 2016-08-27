require 'spec_helper'

describe OptionNamesService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      option_names: [option_name1]
    )
  end

  let :option_name1 do
    double(
      :option_name1,
      id: 1,
      position: 1,
      title: "new option_name"
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
    subject(:service) { OptionNamesService.new(insales_product, product)}
    it "should create option_names for product" do
      service.create
      expect(Product.last.option_names.count).to eq(1)
      expect(Product.last.option_names.last.insales_option_id).to eq(1)
      expect(Product.last.option_names.last.title).to eq("new option_name")
    end
  end

  context "#update" do
    subject(:service) { OptionNamesService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        option_names: [option_name1, option_name2]
      )
    end

    let :option_name2 do
      double(
        :option_name2,
        id: 2,
        position: 2,
        title: "option_name2"
      )
    end

    before :each do
      product.option_names.create(insales_option_id: 1,
                            position: 2,
                            title: "title1")
      product.option_names.create(insales_option_id: 3,
                            position: 1,
                            title: "title3")
    end
    it "should delete option_names which are not anymore in insales" do
      expect(Product.last.option_names.map(&:insales_option_id)).to eq([1, 3])
      service.update
      expect(Product.last.option_names.count).to eq(2)
      expect(Product.last.option_names.map(&:insales_option_id)).not_to include(3)
    end

    it "should create option_names which were not in app" do
      service.update
      expect(Product.last.option_names.map(&:insales_option_id)).to include(2)
    end

    it "should update option_names existing in both systems" do
      service.update
      upd_option_name = Product.last.option_names.find_by(insales_option_id: 1)
      expect(upd_option_name.title).to eq("new option_name")
    end
  end
end
