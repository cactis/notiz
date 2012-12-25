# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "Notiz<no-reply@#{Settings.domain}>", :return_path => '#{Settings.admin_emails}'
  layout 'mail'

  include NotificationHelper
  helper :notification

  def sharing_create(sharing)
    @sharing = sharing
    @user_title = @sharing.email.split('@')[0]
    @subject = "來自 「#{@sharing.subjectable.name}」 的桌面邀請:"
    mail :to => @sharing.email, :subject => @subject
  end

  def note_create(note, user)
    @note = note
    @user = user
    @user_title = @user.name
    @subject = "新增了一張便條紙: #{@note.user.name} 在 #{@note.tag.name } 中新增了一張便條紙 #{@note.subject}"
    mail :to => @user.email, :subject => @subject
  end

  def comment_create(comment, user)
    require 'sanitize'
    @comment = comment
    @user = user
    @user_title = @user.name
    @commentable = comment.commentable
    @subject = "[留言通知] #{@comment.user.title} 說: #{Sanitize.clean(@comment.comment)[0..80]}…"
    mail :to => @user.email, :subject => @subject
  end

  def signup_admin_notification(user)
    @mail = APP[:supervisor]
    @user = user
    @user_title = @user.name
    @subject = "有一位新用戶 #{@user.email} 完成註冊動作。"
    mail :to => @mail, :subject => @subject
  end
end
