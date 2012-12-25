class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :type
      t.belongs_to :user
      t.references :tree, :polymorphic => true
      t.string :subject
      t.text :body
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :posts, :type
    add_index :posts, :user_id
    add_index :posts, :subject
    add_index :posts, :deleted_at
    add_index :posts, :updated_at
    add_index :posts, :created_at
  end

end

