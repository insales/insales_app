class CreateCollects < ActiveRecord::Migration
  def change
    create_table :collects do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :insales_collection_id, index: true

      t.timestamps
    end
  end
end
