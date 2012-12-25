# encoding: utf-8
class Picture < Asset

  serialize :options
  custom_options = [
    ["width", 'Integer', nil],
    ["height", 'Integer', nil]
  ]
  acts_as_custom_options custom_options

  def clips
    # 用 filename 反查 Clip，不嚴謹。
    Clip.where(["body regexp ?", filename])
  end

  def iconfile
   "/thumb/#{self.filename}"
  end

  def image_versions
    # {"t" => "64x64",  "s" => "256x256",  "m" => "512x512",  "l" => "1024x1024",  "o" => '10000x10000'}
    {"thumb" => "128x128>", "small" => "256x256>", "medium" => "512x512>", "large" => "1024x1024>", "original" => "#{width}x#{height}>"}
    #{"thumb" => 0.1, "small" => 0.25, "medium" => 0.5, "large" => 0.75, "original" => 1}
  end

  def binary_data
    # data = self[:binary_data].gsub('data:image/jpeg;base64,', '').gsub('data:image/png;base64,', '').gsub('data:image/gif;base64,', '')
    data = self[:binary_data].gsub(/data.*base64,/, '')
    # data = Base64.decode64(data)
  end

  def tmp_filename(opts = {})
    "#{cache_folder}/#{filename.split('.').insert(1, size(opts)).join('.')}"
  end

  def data(opts = {})
    tmpfile = tmp_filename(opts)
    if !File.exists?(tmpfile)
      size_key = size(opts)
      size_value = image_versions[size_key]
      img = imgdata
      #  if self.width.nil?
      #    self.width = img[:width]
      #    self.height = img[:height]
      #    self.save_without_timestamping
      #  end
      img.resize size_value unless size_key == "original"
      img.write(tmpfile)
    end
    File.open(tmpfile).read
    # rescue
  end

  def imgdata
    data = binary_data
    data = Base64.decode64(data)
    MiniMagick::Image.read(data)
  end

  def ext_name
    content_type.split('/')[1].downcase
  end

  def size(opts = {})
    (opts[:size] || :small).to_s
  end

  def default_width
    image_versions["small"].split('x')[0].to_i
  end

  def default_height
    (imgdata[:height].fdiv(imgdata[:width]) * default_width).to_i - 10
  end

  def cache_folder
    dir = "#{Rails.root}/tmp/pictures"
    Dir.mkdir dir unless Dir.exists?(dir)
    return dir
  end
end

