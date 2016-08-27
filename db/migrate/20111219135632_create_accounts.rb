class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.text    :insales_subdomain,   null: false
      t.text    :password,            null: false
      t.integer :insales_id,          null: false
      t.timestamps
    end
    add_index :accounts, [:insales_subdomain], unique: true
  end

  def self.down
    drop_table :accounts
  end
end
