# encoding: utf-8
class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    # 寄給該留言所在的所有參與者
    # return unless users = (self.commentable.comments.includes(:user).map{|c| c.user} + [self.commentable.user, self.commentable.tag.user]).uniq - [User.current]
    # 寄給該留言所在的桌面的所有成員
    return unless _users = comment.commentable.tag.users_with_owner - [User.current]
    _users.each do |user|
      UserMailer.comment_create(comment, user).deliver
    end
  end

  def before_destroy(comment)
    raise "非本人不能刪除。" unless comment.owned? || comment.commentable.owned? || comment.commentable.tag.owned?
  end

  def before_save(comment)
    comment.comment = comment.comment.gsub(/<script.*?>[\s\S]*<\/script>/i, "") if comment.comment
  end
end

