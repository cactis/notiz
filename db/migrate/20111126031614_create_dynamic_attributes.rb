class CreateDynamicAttributes < ActiveRecord::Migration
  def self.up
    create_table(:dynamic_attributes) do |t|
      t.string :name#, :null => false
      t.string :attr_key, :null => false
      t.string :object_type, :null => false
      t.string :attributable_type, :null => false
      t.integer :attributable_id, :null => false
      %w(integer string boolean text float).each do |type|
        t.send(type, "#{type}_value".to_sym)
      end
    end

    add_index "dynamic_attributes", ["attributable_id"], :name => "index_dynamic_attributes_on_attributable_id"
    add_index "dynamic_attributes", ["attributable_type"], :name => "index_dynamic_attributes_on_attributable_type"
    add_index "dynamic_attributes", ["attr_key"], :name => "index_dynamic_attributes_on_attr_key"

    create_table(:dynamic_attribute_definitions) do |t|
      t.text :definition
      t.string :attribute_defineable_type, :null => false
      t.integer :attribute_defineable_id, :null => false
    end

    add_index "dynamic_attribute_definitions", ["attribute_defineable_id"], :name => "index_dynamic_attribute_definitions_on_attribute_defineable_id"
    add_index "dynamic_attribute_definitions", ["attribute_defineable_type"], :name => "index_dynamic_attribute_definitions_on_attribute_defineable_type"
  end

  def self.down
    remove_index "dynamic_attribute_definitions", :name => "index_dynamic_attribute_definitions_on_attribute_defineable_id"
    remove_index "dynamic_attribute_definitions", :name => "index_dynamic_attribute_definitions_on_attribute_defineable_type"

    drop_table(:dynamic_attribute_definitions)

    remove_index "dynamic_attributes", :name => "index_dynamic_attributes_on_attr_key"
    remove_index "dynamic_attributes", :name => "index_dynamic_attributes_on_attributable_type"
    remove_index "dynamic_attributes", :name => "index_dynamic_attributes_on_attributable_id"

    drop_table(:dynamic_attributes)
  end
end

