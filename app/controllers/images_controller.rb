class ImagesController < AssetsController

  def index
    @images = Image.order('id desc').page(params[:page])#.per(5)
  end
end
