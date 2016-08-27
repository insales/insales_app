class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :variant, index: true, foreign_key: true
      t.integer :insales_option_value_id, null: false, unique: true, index: true
      t.integer :insales_option_id
      t.integer :position
      t.string :title

      t.timestamps
    end
  end
end
