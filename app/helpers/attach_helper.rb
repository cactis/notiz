module AttachHelper
  def attach_path(attach)
    "/#{attach.class.to_s.downcase.pluralize}/#{attach.filename}"
  end
end

