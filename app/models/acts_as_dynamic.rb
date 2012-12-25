module ActsAsDynamic
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    #    after_create do |r|
    #      r.add_dynamic_attribute(:width, 'integer')
    #      r.width = 300
    #      r.add_dynamic_attribute(:height, 'integer')
    #      r.height = 200
    #      r.save
    #    end
    def acts_as_dynamic
      # model_id = self.to_s.split('::').last.sub(/Controller$/,'').pluralize.singularize.underscore unless model_id
      #@acts_as_movable_config = ActsAsMovable::Config.new(model_id)
      #include ActsAsMovable::InstanceMethods
    end
  end

  module InstanceMethods
    def width
      read_datt :width
      100
    end

    def height
      read_datt :height
    end

    def width=(value)
      write_datt :width, value.to_i
    end

    def height=(value)
      write_datt :height, value.to_i
    end
  end
end

