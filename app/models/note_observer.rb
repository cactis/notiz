class NoteObserver < ActiveRecord::Observer
  #  def after_create(record)
  #    return unless record.tag && _users = record.tag.users_with_owner - [User.current]
  #    _users.each do |user|
  #      UserMailer.note_create(record, user).deliver
  #    end
  #  end
end

