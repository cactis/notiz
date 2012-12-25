class Post < ActiveRecord::Base
  belongs_to :tree
  belongs_to :tag, :foreign_key => 'tree_id', :class_name => "Tag"
  belongs_to :user

  acts_as_commentable

#  default_scope lambda {
#    select("#{self.base_class.to_s.downcase.pluralize}.*")
#    .joins("left join interactions on thingable_id = #{self.base_class.to_s.downcase.pluralize}.id")
#    .where( ["#{self.base_class.to_s.downcase.pluralize}.user_id = ? or
#              ( interactions.type = 'Sharing' and s_active = 1 and o_active = 1 and
#                thingable_type = '#{self.base_class.to_s}' and
#                objectable_type = 'User' and objectable_id = ?)",
#      User.current.id, User.current.id])
#    .joins("inner join trees on trees.id = tree_id")
#  }

  default_scope lambda{
    select("posts.*")
    .group("posts.id")
    .joins("left join interactions on thingable_id = tree_id")
    .where(User.current ? ["posts.user_id = ? or
      (tree_id = 100) or
      (subjectable_type = 'User' and subjectable_id = ?) or
      (objectable_type = 'User' and objectable_id = ? or
      email = '#{User.current.email}'
    )", User.current.id, User.current.id, User.current.id] : "1 < 1")
  }

#  before_save :security
#  def security
#    self.subject = self.subject.gsub(/<script.*?>[\s\S]*<\/script>/i, "") if subject
#    self.body = self.body.gsub(/<script.*?>[\s\S]*<\/script>/i, "") if body
#  end

  serialize :options
  custom_options = [
    [:subject_background, 'String', '#f0f4b7'],
    [:body_background, 'String', '#f0f4b7'],
    [:width, 'Integer', 300],
    [:height, 'Integer', 200],
    [:left, 'Integer', nil],
    [:top, 'Integer', nil],
    [:timestamping, 'String', nil],
    [:classes, 'String', ''],
    [:lock, 'Boolean', true]
  ]
  acts_as_custom_options custom_options


  %w(nborder nshadow nradius nnote).each do |klas|
    class_eval %(
      def #{klas}
        self.classes.split(' ').include?('#{klas}')
      end

      def #{klas}=value
        ary = classes.split(' ')
        eval(value) ? ary.push("#{klas}") : ary.delete("#{klas}")
        self.classes = ary.uniq.join(' ')
      end
    )
  end
end

