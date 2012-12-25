# encoding: utf-8
class PostObserver < ActiveRecord::Observer
  def before_destroy(record)
    raise "非本人不能刪除。" unless record.admin?
  end

  def before_save(record)
    return if record.new_record?
    raise '更新失敗。本物件已被作者鎖定。請利用留言板與作者討論。' unless record.owned? || !record.lock # 除非是本人或非鎖定狀態
    record.subject = record.subject.gsub(/<script.*?>[\s\S]*<\/script>/i, "") if record.subject
    record.body = record.body.gsub(/<script.*?>[\s\S]*<\/script>/i, "") if record.body
  end
end

