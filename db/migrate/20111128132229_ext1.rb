class Ext1 < ActiveRecord::Migration
  def up
    add_column :posts, :width, :integer
    add_column :posts, :height, :integer
    add_column :posts, :binary_data, :binary
    add_column :users, :tags_list, :text
  end

  def down
  end
end

