class CreateOptionNames < ActiveRecord::Migration
  def change
    create_table :option_names do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :insales_option_id, index: true, unique: true, null: false
      t.integer :position
      t.string :title

      t.timestamps
    end
  end
end
