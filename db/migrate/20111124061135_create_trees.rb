class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.string :type
      t.belongs_to :user
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :trees, :type
    add_index :trees, :name
    add_index :trees, :parent_id
    add_index :trees, :lft
    add_index :trees, :rgt

    add_index :trees, :user_id
    add_index :trees, :deleted_at
    add_index :trees, :created_at
    add_index :trees, :updated_at
  end
end

