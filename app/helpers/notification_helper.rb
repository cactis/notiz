# encoding: utf-8
module NotificationHelper
  def notification_link(notification)
    case notification.class.to_s
    when "Sharing"
      "一個來自 #{notification.subjectable.username} 的桌面「#{Tag.unscoped.find(notification.thingable_id).name}」分享: #{link_to '啟用桌面', notification.activate_url}".html_safe
    end
  end
end

