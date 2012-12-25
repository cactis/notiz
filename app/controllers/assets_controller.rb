class AssetsController < ApplicationController
  def create
    @asset = current_path[0].classify.constantize.create(params[:asset])
    respond_to do |format|
      format.js {}
    end
  end

  def show
    @asset = Asset.find_by_token(params[:id])
    data = @asset.data(:size => params[:size])
    respond_to do |format|
      format.any(:jpeg, :jpg, :png, :gif) {
        send_data data, :type => @asset.content_type, :disposition => 'inline', :filename => @asset.token
      }
    end
  end
end
