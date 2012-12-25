class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :limit => 100, :default => ""
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :user
      t.string :token, :unique => true
      t.binary    :options, :limit => 16.megabyte
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
    add_index :comments, :token
  end

  def self.down
    drop_table :comments
  end
end

