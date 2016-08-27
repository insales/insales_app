class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :insales_variant_id, index: true, null: false, unique: true
      t.string :barcode
      t.decimal :cost_price
      t.decimal :old_price
      t.decimal :price, null: false
      t.string :sku
      t.datetime :insales_created_at
      t.datetime :insales_updated_at
      t.string :title
      t.decimal :quantity
      t.decimal :weight

      t.timestamps
    end
  end
end
