require 'spec_helper'

describe ProductsController do
  render_views

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      archived:                     false,
      available:                    true,
      canonical_url_collection_id:  "",
      collections_ids:              [],
      images:                       [],
      option_names:                 [],
      properties:                   [],
      characteristics:              [],
      variants:                     [],
      category_id:                  1,
      created_at:                   "2016-05-21 14:22:17 +0300",
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
      title:                        "Fresh updated product",
      id:                           1,
      updated_at:                   "2016-05-21 14:22:17 +0300"
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

  let :installed_app do
    MyApp.new(default_account.insales_subdomain, default_account.password)
  end

  describe "#update" do
    before do
      controller.stub(:authentication)
      controller.stub(:current_account) { default_account }
      controller.stub(:configure_api)
      controller.stub(:product_from_api) { insales_product }
    end
    it "updates product" do
      patch :update, id: product

      expect(response).to redirect_to(product_path)
      expect(Product.last.title).to eq("Fresh updated product")
    end
  end
end
