class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :insales_property_id, index: true, unique: true, null: false
      t.boolean :backoffice, default: false, null: false
      t.boolean :is_hidden, default: false, null: false
      t.boolean :is_navigational, default: false, null: false
      t.integer :position
      t.string :permalink
      t.string :title

      t.timestamps
    end
  end
end
