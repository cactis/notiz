# encoding: utf-8
class Attach < Asset

  def binary_data
    pre, data = self[:binary_data].split('base64,')
    Base64.decode64(data)
  end

  def ext_name
    file_name.split('.').last.downcase
  end

  def iconfile
     if %w(js xls xlsx doc docx pdf zip rar csv txt css json html php ico gem gz tar).include?(self.ext_name)
       "icons_#{self.ext_name}"
     else
       "icons_attach"
     end
  end
end
