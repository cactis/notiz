class AddToken < ActiveRecord::Migration
  def up
    add_column :users, :token, :string, :unique => true
    add_column :trees, :token, :string, :unique => true
    add_column :posts, :token, :string, :unique => true
    add_column :assets, :token, :string, :unique => true

    add_index :users, :token
    add_index :trees, :token
    add_index :posts, :token
    add_index :assets, :token

    remove_index :interactions, :token
    add_index :interactions, :token, :unique => true
  end

  def down
    remove_index :users, :token
    remove_index :trees, :token
    remove_index :posts, :token
    remove_index :assets, :token

    remove_column :users, :token
    remove_column :trees, :token
    remove_column :posts, :token
    remove_column :assets, :token
  end
end

