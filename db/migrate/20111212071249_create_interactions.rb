class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.string    :type,       :limit => 20
      t.references :subjectable,:polymorphic => true
      t.references :objectable, :polymorphic => true
      t.references :thingable,  :polymorphic => true
      t.boolean   :s_active,    :default => true
      t.boolean   :o_active,    :default => false
      t.string    :token, :unique => true
      t.string    :email
      t.belongs_to   :user
      t.binary    :options, :limit => 16.megabyte
      t.timestamp :deleted_at, :default => nil
      t.timestamps
    end

    add_index :interactions, :type
    add_index :interactions, :subjectable_type
    add_index :interactions, :subjectable_id
    add_index :interactions, :objectable_type
    add_index :interactions, :objectable_id
    add_index :interactions, :thingable_type
    add_index :interactions, :thingable_id
    add_index :interactions, :token
    add_index :interactions, :email
    add_index :interactions, :s_active
    add_index :interactions, :o_active
    add_index :interactions, :user_id
    add_index :interactions, :deleted_at
    add_index :interactions, :updated_at
    add_index :interactions, :created_at
    add_index :interactions, [:subjectable_type, :subjectable_id]
    add_index :interactions, [:objectable_type, :objectable_id]
    add_index :interactions, [:thingable_type, :thingable_id]
  end
end

