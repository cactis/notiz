# encoding: utf-8
class UserObserver < ActiveRecord::Observer
  def after_create(record)
    body = %(<p>
	        這是第一張便條紙。</p>
      <div id="">
      	您可以用桌面右上角的新增按鈕增加新的便條紙。</div>
    )
    tag = record.tags.create!(:name => '桌面1')
    tag.notes.create!(:user_id => record.id, :subject => '我的第一張便條紙', :body => body)
  end
end

