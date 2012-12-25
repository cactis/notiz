class Clip < Post

  def subject
    self.source.title || self.source.file_name
  end

  #  def body
  #    self[:body].scan(/style=.*width/) ? self[:body].
  #  end

  attr_accessor :source

  def source
    return unless body
    filename = body.split('/')[3].split('.')[0]
    Asset.find_by_token(filename)# || Asset.find_by_file_name(filename) #Image.find_by_file_name(filename)
  end

  def source_size
    [source.imgdata[:width], source.imgdata[:height]]
  end

  def width
    # return unless source
    return options[:width] if options && options[:width]
    if source
      self.width = source.image_versions["small"].split('x')[0].to_i
      self.save_without_timestamping
    end
  end

  def height
    #[source_size[0], source_size[1]]
    # return unless source
    return options[:height] if options && options[:height]
    if source
      self.height = (source_size[1].fdiv(source_size[0]) * width).to_i
      self.save_without_timestamping
    end
  end
end

