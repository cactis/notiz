# encoding: utf-8
class Sharing < Interaction
  # 同一分享只能建立一次
  validates_uniqueness_of :type, :scope => [  :subjectable_type, :subjectable_id,
                                              :thingable_type, :thingable_id,
                                              :email
                                            ]

  #  # 不是擁有者不能分享
  #  before_create :check_thingable_owner
  #  def check_thingable_owner
  #    raise "You are not owner!" unless thingable.user == User.current || Tag.find(thingable.tag.id)
  #  end

  #  after_create :send_notification!
  #  def send_notification!
  #    UserMailer.sharing_create(self).deliver
  #  end

  #  def destroy
  #    if owned?
  #      self.s_active = false
  #      self.save
  #    else self.email == User.current.email
  #      self.o_active = false
  #      self.save
  #    end
  #  end

  def destroy
    if self.owned?
      super
    elsif self.email == User.current.email
      self.o_active = false
      self.save!
    else
      raise "必須是桌面主人或被邀請者本人才能退出。"
    end
  end

  def activate!
    self.objectable = User.current
    self.o_active = true
    self.save
    # share_with_posts
  end

  def activate_path
    "/sharings/#{self.token}"
  end

  def activate_url
    "#{APP[:url]}#{activate_path}"
  end

  #  private
  #  def share_with_posts
  #    if thingable.is_a?(Tag)
  #      Post.unscoped.where(["tree_id = ?", thingable.id]).each do |post|
  #        Sharing.build!(self.subjectable, self.objectable, post)
  #        Sharing.build!(self.subjectable, self.objectable, post.source) if post.source
  #      end
  #    end
  #  end

  #  def self.build!(subjectable, objectable, thingable)
  #    sharing = self.new
  #    sharing.subjectable = subjectable
  #    # sharing.objectable = objectable
  #    sharing.thingable = thingable
  #    sharing.o_active = true
  #    sharing.save
  #  end
end

