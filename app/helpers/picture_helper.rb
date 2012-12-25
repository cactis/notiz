module PictureHelper
  def picture_path(picture, opts = {})
    size = (opts[:size] || :small).to_s
    "/#{picture.class.to_s.downcase.pluralize}/#{size}/#{picture.filename}"
  end
end

