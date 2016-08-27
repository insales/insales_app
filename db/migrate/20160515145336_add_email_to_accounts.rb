class AddEmailToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :email, :text
  end

  def down
    remove_column :accounts, :email
  end
end
