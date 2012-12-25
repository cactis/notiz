class PictureObserver < ActiveRecord::Observer
  def after_destroy(record)
    system "rm #{record.cache_folder}/#{record.filename[0, 20]}*"
  end

  def before_create(record)
    record.width = record.imgdata[:width]
    record.height = record.imgdata[:height]
  end
end

