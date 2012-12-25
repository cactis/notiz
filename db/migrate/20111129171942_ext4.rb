class Ext4 < ActiveRecord::Migration
  def up
    add_column :posts, :subject_background, :string
    add_column :posts, :body_background, :string
  end

  def down
  end
end

