# encoding: utf-8
class SharingObserver < ActiveRecord::Observer
  # 不是擁有者不能分享
  def before_create(sharing)
    raise "必須是桌面建立者才能分享!" unless sharing.thingable.owned? # == User.current #  || Tag.find(sharing.thingable.tag.id) # 後面這段看不懂
  end

  def after_create(sharing)
    UserMailer.sharing_create(sharing).deliver
  end

  # 不能作用
  #  def before_destroy(record)
  #    if record.owned?
  #    elsif record.email && record.email == User.current.email
  #      record.o_active = false
  #      record.save!
  #      false
  #    else
  #      raise "必須是桌面主人或被邀請者本人才能退出。"
  #    end
  #  end
end

