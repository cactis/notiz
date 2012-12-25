# encoding: utf-8
class InteractionObserver < ActiveRecord::Observer
  def before_create(record)
    return unless User.current
    record.subjectable_type = 'User'
    record.subjectable_id = User.current.id
    # self.o_active = true
  end
end

