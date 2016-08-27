class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean   :archived, default: false, null: false
      t.boolean   :available, default: false, null: false
      t.integer   :canonical_url_collection_id
      t.integer   :category_id, null: false
      t.datetime  :insales_created_at, null: false
      t.boolean   :is_hidden, default: false, null: false
      t.string    :sort_weight
      t.string    :unit
      t.text      :short_description
      t.string    :permalink, null: false
      t.text      :html_title
      t.text      :meta_keywords
      t.text      :meta_description
      t.string    :currency_code
      t.text      :description

      t.text :title
      t.integer :insales_product_id, index: true, null: false
      t.datetime :insales_updated_at, index: true

      t.timestamps
    end

    add_reference :products, :account, index: true, foreign_key: true
  end
end
