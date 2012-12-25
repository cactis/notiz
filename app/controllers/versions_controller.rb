# encoding: utf-8
class VersionsController < ApplicationController
  # 目前只適用在 Note

  def index
    note_id = params[:note_id]
    @note = Note.find(note_id)
    @version_id = params[:version_id].to_i

    @version = @note.versions[@version_id]
    render :action => :show, :layout => false
  end

  def show
    # debug params[:note_id]
    render :text => params[:note_id]
  end
end

