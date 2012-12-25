class Ext2 < ActiveRecord::Migration
  def up
    add_column :trees, :notes_list, :text
    add_column :trees, :float, :boolean
  end

  def down
  end
end

