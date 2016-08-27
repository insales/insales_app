require 'spec_helper'

describe ImagesService do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :insales_product do
    double(
      :insales_product,
      images: [image1]
    )
  end

  let :image1 do
    double(
      :image1,
      id: 1,
      created_at: "2016-05-21 14:22:17 +0300",
      position: 1,
      original_url: "https://pp.vk.me/c62424/v62424771/36f6e/zO2Kh5o.jpg",
      title: "new title in insales",
      filename: "filename.jpg"
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
    subject(:service) { ImagesService.new(insales_product, product)}
    it "should create images for product" do
      service.create
      expect(Product.last.images.count).to eq(1)
      expect(Product.last.images.last.insales_image_id).to eq(1)
      expect(Product.last.images.last.title).to eq("new title in insales")
    end
  end

  context "#update" do
    subject(:service) { ImagesService.new(insales_product1, product)}

    let :insales_product1 do
      double(
        :insales_product1,
        images: [image1, image2]
      )
    end

    let :image2 do
      double(
        :image2,
        id: 2,
        created_at: "2016-05-20 14:22:17 +0300",
        position: 2,
        original_url: "https://pp.vk.me/c62424/zO2Kh5o.jpg",
        title: "title2",
        filename: "filename2.jpg"
      )
    end

    before :each do
      product.images.create(insales_image_id: 1,
                            insales_created_at: "2016-05-21 14:22:17 +0300",
                            position: 1,
                            original_url: "https://pp.vk.me/c62424/v62424771/36f6e/zO2Kh5o.jpg",
                            title: "title1",
                            filename: "filename.jpg")
      product.images.create(insales_image_id: 3,
                            insales_created_at: "2016-05-21 14:22:17 +0300",
                            position: 1,
                            original_url: "https://pp.vk.me/c62424/v62424771/36f6e/zO2Kh5o.jpg",
                            title: "title3",
                            filename: "filename3.jpg")
    end
    it "should delete images which are not anymore in insales" do
      expect(Product.last.images.map(&:insales_image_id)).to eq([1, 3])
      service.update
      expect(Product.last.images.count).to eq(2)
      expect(Product.last.images.map(&:insales_image_id)).not_to include(3)
    end

    it "should create images which were not in app" do
      service.update
      expect(Product.last.images.map(&:insales_image_id)).to include(2)
    end

    it "should update images existing in both systems" do
      service.update
      upd_image = Product.last.images.find_by(insales_image_id: 1)
      expect(upd_image.title).to eq("new title in insales")
    end
  end
end
