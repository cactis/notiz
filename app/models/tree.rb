class Tree < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :assets, :as => :asseted, :dependent => :destroy

  has_many :wallpapers, :as => :asseted

  has_many :notes, :as => :tree
  has_many :clips, :as => :tree

  has_many :attaches, :as => :asseted
  has_many :pictures, :as => :asseted

  belongs_to :user

  has_many :interactions, :foreign_key => 'thingable_id', :class_name => 'Interaction', :dependent => :destroy

  has_many :sharings, :as => :thingable, :conditions => ["s_active = ?", true]
  #has_many :objectables, :through => :sharings, :source => :objectable

  def users
    sharings.map{|s| s.objectable}.compact
  end

  def users_with_owner
    users + [self.user]
  end

  default_scope lambda {
    select("trees.*")
    .group("trees.id")
    .joins("left join interactions on thingable_id = trees.id")
    .where( User.current ? ["trees.user_id = ? or
              (trees.id = 100) or
              ( interactions.type = 'Sharing' and s_active = 1 and o_active = 1 and
                thingable_type = 'Tree' and
                objectable_type = 'User' and objectable_id = ?)
              ",
      User.current.id, User.current.id] : "1 < 1")
  }
end

