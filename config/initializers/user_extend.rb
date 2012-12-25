# -*- encoding : utf-8 -*-
module UserExtend
  def current
    Thread.current[:user]
  end

  def current=(user=nil)
    raise(ArgumentError, "傳入參數必需為 User 物件.") unless user.is_a?(User) || user.nil?
    Thread.current[:user] = user
  end
end

