# encoding: utf-8
class Tag < Tree

  serialize :options
  custom_options = [
    ['notes_list', 'String', '99999'],
    ['float', 'Boolean', true],
    ['background', 'String', '/assets/bg/bg39.jpg'],
    ['background_color', 'String', '#ff0000'],
    ['sharing_info', 'String', 'Hi, 我有一個桌面要分享給你~'],
    ['sharing_mail_lists', 'String', '']
  ]
  acts_as_custom_options custom_options

  def posts_order_by_float(opts = {})
    # 分頁載入
    page = opts[:page] ? opts[:page].to_i : 1
    list = notes_list
    posts.order("field (posts.id, #{list.present? ? list : '00000000'})").page(page).per(30)
  end

  def name
    # 個人對標籤的自訂名稱優先於原分享者的命名
    return unless User.current
    if self.owned?
      self[:name].present? ? self[:name] : "(我的桌面)"
    else
      (User.current.tagnames && User.current.tagnames[self.id.to_s].present?) ? User.current.tagnames[self.id.to_s] : (self[:name].present? ? self[:name] : "(我的桌面)")
    end
  end

  def name=value
    if user_id.nil? || self.owned?
      self[:name] = value
    else
      user = User.current
      user.tagnames = {self.id.to_s => value}
      user.save_without_timestamping
    end
  end

  def notes_list
    if options && options[:notes_list]
      float ? options[:notes_list] : options[:notes_list].split(',').reverse.join(',')
    else
       (posts.present? ? posts.map{|note| note.id}.join(',') : '999999999')
    end
  end

  def mode
    float ? 'float' : 'absolute'
  end
end

