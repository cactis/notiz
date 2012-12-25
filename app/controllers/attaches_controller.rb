class AttachesController < AssetsController
  def show
    @attach = Attach.find_by_token(params[:id])
    send_data @attach.binary_data, :type => @attach.content_type, :disposition => 'attachment', :filename => @attach.file_name
  end

  def destroy
    @attach = Attach.find(params[:id])
    if @attach.destroy
      respond_to do |format|
        format.json { render :text => '' }
        format.js{ render :text => 'delete!'}
      end
    end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end
end

