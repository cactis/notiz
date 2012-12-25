class ClipObserver < ActiveRecord::Observer

  #  def after_destroy(record)
  #    record.source.destroy
  #    rescue
  #  end

  def after_update(record)
    record.source.update_attributes(:asseted_id => record.tree_id) if record.tree_id != record.source.asseted_id
  end

end

