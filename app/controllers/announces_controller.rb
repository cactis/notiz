class AnnouncesController < ApplicationController
  def index
    if supervisor?
      @announces = Announce.order('id desc').page(params[:page])
    else
      redirect_to root_path
    end
  end

  def create
    @announce = Announce.create(params[:announce])
    if @announce.save
      respond_to do |format|
        format.js {}
        # render @announce, :layout => false, :content_type => :html
      end
    end
  end
end

