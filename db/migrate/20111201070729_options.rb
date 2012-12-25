class Options < ActiveRecord::Migration
  def up
    add_column :users, :options, :binary, :limit => 16.megabyte
    add_column :trees, :options, :binary, :limit => 16.megabyte
    add_column :posts, :options, :binary, :limit => 16.megabyte
  end

  def down
  end
end

