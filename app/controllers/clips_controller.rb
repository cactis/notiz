# encoding: utf-8
class ClipsController < PostsController
  respond_to :js, :html

  def create
    @tag = params[:tag_id] ? Tag.find(params[:tag_id]) : Tag.order('id').first

    @clip = @tag.clips.create!(params[:clip])

    respond_to do |format|
      format.js{ render @clip, :content_type => :html, :layout => false}
    end
  end

  def update
    @clip = Clip.find(params[:id])
    @clip.update_attributes(params[:clip])
    flash[:notice] = '圖卡更新完成。'

    respond_with @clip do |format|
      format.js { }
      format.html { redirect_to tag_clips_path(@clip.tag), :notice => flash[:notice] }
    end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end

  def show
    @clip = Clip.find(params[:id])
    render :layout => false
  end
end
