# encoding: utf-8

class TreeObserver < ActiveRecord::Observer
  def before_update(record)
    if record.background == ''
      record.wallpapers.destroy_all
    end
  end
end

