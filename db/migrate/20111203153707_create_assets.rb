class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.belongs_to :user
      t.string :title
      t.references :asseted, :polymorphic => true
      t.string :file_name
      t.string :file_size
      t.string :content_type
      t.binary :binary_data, :limit => 16.megabyte
      t.boolean :active
      t.boolean :public
      t.binary :options, :limit => 16.megabyte
      t.timestamp :deleted_at, :default => nil
      t.timestamps
    end

    add_index :assets, :type
    add_index :assets, :title
    add_index :assets, [:asseted_type, :asseted_id]
    add_index :assets, :file_name
    add_index :assets, :file_size
    add_index :assets, :content_type
    add_index :assets, :active
    add_index :assets, :public

    add_index :assets, :user_id

    add_index :assets, :deleted_at
    add_index :assets, :updated_at
    add_index :assets, :created_at
  end
end

