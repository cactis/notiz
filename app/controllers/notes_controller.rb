# encoding: utf-8
class NotesController < PostsController
  respond_to :js, :html
  layout "notes"
  before_filter :tag

  def index
    @notes = @tag.posts_order_by_float(:page => params[:page])
    debug @tag.notes_list

    gon.num_pages = @notes.num_pages

    debug gon.num_pages

    respond_to do |format|
      format.js {
        if params[:page]
          if @notes.present?
            render :action => "page", :content_type => :html, :layout => false
          else
            render :text => nil, :status => 404
          end
        else
          render :content_type => :html, :layout => false
        end
      }
      format.html{ }
      #format.mobile{ render :layout => false}
    end
  end

  def show
    @note = Note.find(params[:id])
    # render @note, :layout => false
    respond_to do |format|
      format.html{ render  :layout => 'notes_show'}
    end
  end

  def create
    @tag = params[:tag_id] ? Tag.find(params[:tag_id]) : Tag.order('id').first
    flash[:notice] = "新增便條紙。" if @note = @tag.notes.create!(params[:note])

    respond_to do |format|
      format.js{ render @note, :content_type => :html, :layout => false}
      # format.js { render :json => @note, :content_type => 'text/json' }
    end
  end

  def edit
    @note = Note.find(params[:id])
    respond_to do |format|
      format.js {}
      format.html {}
    end
    # render :layout => false
  end

  #  def status
  #    @note = Note.find(params[:note][:id])
  #    @msg = {:note => @note.id, "locking" => params[:note][:locking]}
  #    respond_with do |format|
  #      format.js{ }
  #    end
  #  end

  def update
    @note = Note.find(params[:id])
    @note.update_attributes(params[:note])
    @keys = params[:note].keys
    debug @token
    flash[:notice] = '便條紙更新完成。'
    respond_with @note do |format|
      format.js { }
      format.html {
        redirect_to tag_notes_path(@note.tag), :notice => flash[:notice]
      }
    end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end

  private
  def tag
    return unless params[:tag_id]
    @tag = Tag.find(params[:tag_id])
  end
end
