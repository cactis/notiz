# encoding: utf-8
class CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    debug @post, '@post'
    @comments = @post.comments#.order('created_at desc')
    render :layout => false
  end

  def create
    post_id = params[:note_id] || params[:clip_id]
    @post = Post.find(post_id)
    @comment = @post.comments.create(params[:comment])
    if @comment.save
      #@content = render(:partial => '/comments/comment', :locals => {:comment => @comment})[0]
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = "留言已刪除。"
      render :nothing => true
    end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end
end

