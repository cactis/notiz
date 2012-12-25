# encoding: utf-8

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.page(params[:page])
    respond_to do |format|
      format.js{ render :layout => false, :content_type => :html}
      # format.html{}
    end
  end
end

