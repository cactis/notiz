class Asset < ActiveRecord::Base
  belongs_to :tree, :foreign_key => "asseted_id", :class_name => "Tree"
  belongs_to :asseted, :polymorphic => true

  default_scope lambda{
    select("assets.*")
    .group("assets.id")
    .joins("left join interactions on thingable_id = asseted_id")
    .where(User.current ? ["assets.user_id = ? or
      (asseted_id = 100) or
      (subjectable_type = 'User' and subjectable_id = ?) or
      (objectable_type = 'User' and objectable_id = ? or
      email = '#{User.current.email}'
      )", User.current.id, User.current.id, User.current.id] : "1 < 1")
  }

  belongs_to :user

  paginates_per 3

  serialize :options
  custom_options = [
    ["test1", 'Integer', 5]
  ]
  acts_as_custom_options custom_options

  def filename
    "#{token}.#{ext_name}"
  end

end
