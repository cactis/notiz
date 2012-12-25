# encoding: utf-8
class AttachObserver < ActiveRecord::Observer
  def before_destroy(record)
    raise "只有桌面主人或物件擁有者才能刪除物件。" unless record.admin?
  end
end

