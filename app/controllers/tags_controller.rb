# encoding: utf-8

class TagsController < ApplicationController
  respond_to :js, :html

  def index
    render :json => Tag.select("id, name")
  end

  def new
    @tag = Tag.new
    render :layout => false
  end

  def edit
    @tag = Tag.find(params[:id])
    render :layout => false
  end

  def show
    redirect_to tag_notes_path(Tag.find(params[:id]))
    # @tag = Tag.find(params[:id])
  end

  def create
    @tag = Tag.create(params[:tag])
    if @tag.save
      flash[:notice] = '已新增桌面。'
      # redirect_to tag_notes_path(@tag), :notice => flash[:notice]
      render :js => "window.location = '/tags/#{@tag.id}/notes'"
    else
    end
  end

  def update
    debug params[:tag]
    @tag = Tag.find(params[:id])
    flash[:notice] = "桌面更新完成。" if @tag.update_attributes(params[:tag])
    respond_to do |format|
      format.json { render :json => @tag.to_json }
      format.js{ render :nil => true}
      format.html {redirect_to tag_notes_path @tag}
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if Tag.all.count > 1
      if @tag.destroy
        flash[:notice] = "己刪除。"
        # redirect_to root_url, :notice => flash[:notice]
        redirect_to tag_notes_path(Tag.first), :notice => flash[:notice]
      end
    else
      flash[:notice] = '無法刪除最後一個桌面。'
      redirect_to @tag, :notice => flash[:notice]
    end
  end
end

