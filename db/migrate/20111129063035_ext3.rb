class Ext3 < ActiveRecord::Migration
  def up
    add_column :posts, :left, :integer
    add_column :posts, :top, :integer
  end

  def down
  end
end

