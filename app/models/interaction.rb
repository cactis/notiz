class Interaction < ActiveRecord::Base

  #  serialize :options
  #  custom_options = [
  #    ['email', 'String', nil]
  #  ]
  #  acts_as_custom_options custom_options

  #  default_scope lambda{
  #    select("assets.*")
  #    .group("assets.id")
  #    .joins("left join interactions on thingable_id = asseted_id")
  #    .where(User.current ? ["assets.user_id = ? or (subjectable_type = 'User' and subjectable_id = ?) or
  #      (objectable_type = 'User' and objectable_id = ? or
  #      email = '#{User.current.email}'
  #      )", User.current.id, User.current.id, User.current.id] : "1 < 1")
  #  }

  #  default_scope lambda {
  #    select("interactions.*")
  #    .group("interactions.id")
  #    .where('s_active =
  #
  #  }


  belongs_to :subjectable, :polymorphic => true
  belongs_to :objectable, :polymorphic => true
  belongs_to :thingable, :polymorphic => true

  belongs_to :tag, :foreign_key => "thingable_id", :class_name => "Tag"

  def token_address
    "#{APP[:url]}/sharings/#{token}"
  end
end

