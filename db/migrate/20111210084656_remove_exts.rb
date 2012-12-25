class RemoveExts < ActiveRecord::Migration
  def up
    #remove_column :trees, :notes_list
    remove_column :trees, :float
    remove_column :posts, :subject_background
    remove_column :posts, :body_background
    remove_column :posts, :left
    remove_column :posts, :top
    remove_column :posts, :width
    remove_column :posts, :height
    remove_column :posts, :binary_data
    remove_column :users, :tags_list
  end

  def down
  end
end

