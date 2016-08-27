class AddColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :updated_since, :datetime
    add_column :accounts, :last_id, :integer
  end
end
