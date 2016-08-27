class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :insales_characteristics_id, index: true, null: false, unique: true
      t.integer :position
      t.integer :insales_property_id
      t.string :title
      t.string :permalink

      t.timestamps
    end
  end
end
