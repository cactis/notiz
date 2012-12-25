# -*- encoding : utf-8 -*-
class ActiveRecord::Base
  # self.include_root_in_json = true

  before_create :init_token
  def init_token
    self.token = self.class.friendly_token if self.has_attribute?(:token)
  end

  def self.friendly_token(n = 15)
    SecureRandom.base64(n).tr('+/=lIO0', 'pqrsxyz')
  end

  def owned?
    User.current && User.current.id == self.user_id
  end

  def admin?
    (User.current && User.current.id == self.user_id) || self.tree.owned?
  end

  def self.acts_as_custom_options(custom_options, opts = {:as => 'options'})
    custom_options.each do |opt|
      # opt = ['background', 'String', '#ccffff']
      key, type, default = opt
      fld_name = opts[:as].to_s
      # 讀取
      case type
      when 'Hash'
        class_eval %(
          def #{key}
            (#{fld_name} && #{fld_name}[:#{key}]) || #{default || 'nil'}
          end

          def #{key}=(value)
            if self.#{fld_name}
              if self.#{fld_name}[:#{key}]
                self.#{fld_name}[:#{key}].merge!(value)
              else
                self.#{fld_name}[:#{key}] = value
              end
            else
              self.#{fld_name} = {:#{key} => value}
            end
          end
        )

      when 'Array'
        # 尚未測試
        class_eval %(
          def #{key}
            (#{fld_name} && #{fld_name}[:#{key}]) || #{default || 'nil'}
          end

          def #{key}=(value)
            (self.#{fld_name} && self.#{fld_name}[:#{key}] = value) || self.#{fld_name} = {:#{key} => value}
          end
        )

      when 'String'
        class_eval %(
          def #{key}
            (#{fld_name} && #{fld_name}[:#{key}]) || "#{default}"
          end

          def #{key}=(value)
            (self.#{fld_name} && self.#{fld_name}[:#{key}] = value || 'nil') || self.#{fld_name} = {:#{key} => value}
          end
        )

      when 'Integer'
        class_eval %(
          def #{key}
            (#{fld_name} && #{fld_name}[:#{key}]) || #{default || 'nil'}
          end

          def #{key}=(value)
            value = value ? value.to_i : nil
            (self.#{fld_name} && self.#{fld_name}[:#{key}] = value || 'nil') || self.#{fld_name} = {:#{key} => value || 'nil'}
          end
        )

      when 'Boolean'
        class_eval %(
          def #{key}
            # 存入時是字串，讀出時作 boolean 值轉換
            Boolean((#{fld_name} && #{fld_name}[:#{key}]) || #{default || 'nil'})
          end

          def #{key}=(value)
            # value = Boolean(value)
            (self.#{fld_name} && self.#{fld_name}[:#{key}] = value || 'nil') || self.#{fld_name} = {:#{key} => value || 'nil'}
          end
        )
      end
    end
  end

  before_create :maintain_owner
  def maintain_owner
    if self.has_attribute?(:site_id) && !self.site_id.present?
      self.site_id = Site.current ? Site.current.id : 1
    end
    if self.has_attribute?(:user_id) && !self.user_id.present?
      self.user_id = User.current ? User.current.id : 1
    end
  end

  def save_without_timestamping
    class << self
      def record_timestamps; false; end
    end
    save
    class << self
      def record_timestamps; super ; end
    end
  end

 def self.debug(*args)
    return unless Rails.env = "development"
    title ||= ""
    logger.ap '-' * 20 + calling_method + '-' * 20
    logger.ap args
    logger.ap '-' * 100
  end

  def debug(*args)
    self.debug(args)
  end

  def Boolean(string)
    return unless string
    return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
    return false if string == false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end
end
