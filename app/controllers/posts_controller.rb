# encoding: utf-8
class PostsController < ApplicationController
  def edit
    @tag = Tag.find(params[:tag_id])
    @post = Post.find(params[:id])
    render :layout => false
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "更新完成。"
      render :nothing => true
    else
      flash[:notice] = "更新失敗。"
      render :nothing => nil, :status => 500, :text => flash[:notice]
    end
  end

  def destroy
    @note = Post.find(params[:id])
    if @note.destroy
      flash[:notice] = '己刪除。'
      respond_to do |format|
        format.js { render :js => "$('##{dom_id(@note)}').fadeOut(1000)" }
      end
    end
#    rescue
#      flash[:error] = "只有桌面主人或物件擁有者才能刪除物件。"
#      debug flash[:error]
#      respond_to do |format|
#        format.js { render :text => nil, :status => 500}
#      end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end
end

