# encoding: utf-8
class SharingsController < InteractionsController

  def index
  end

  def new
    @thing = Tag.find(params[:tag_id])
    @sharing = Sharing.new(:thingable_type => @thing.class.base_class.to_s, :thingable_id => @thing.id)
    render :layout => false
  end

  def show
    debug Sharing.find_by_token(params[:id])
    if @sharing = Sharing.find_by_token(params[:id])
      if @sharing.email == current_user.email
        @sharing.activate!
        flash[:notice] = "您已可使用本桌面。"
        redirect_to tag_notes_path(@sharing.thingable)
      else
        flash[:notice] = '啟用無效。'
        redirect_to root_path
      end
    else
      flash[:notice] = "本連結無效。"
      redirect_to root_path
    end
  end

  def create
    mail_lists = params[:sharing].delete('mail_lists')
    mail_lists.split(/[，；,;]\s*/).each do |mail|
      params[:sharing][:email] = mail
      @sharing = current_user.subject_sharings.create(params[:sharing])
      if @sharing.save
        # flash[:notice] = "已分享給 #{@sharing.email}。"
      else
        if @sharing = Sharing.where(["email = ? and subjectable_type = ? and subjectable_id = ? and thingable_type = ? and thingable_id = ?", params[:sharing][:email], current_user.class.to_s, current_user.id, params[:sharing][:thingable_type], params[:sharing][:thingable_id]]).first
          # flash[:notice] = "已再次發送通知給 #{params[:sharing][:email]}。"
          @sharing.s_active = true
          @sharing.save
          UserMailer.sharing_create(@sharing).deliver
        end
      end
      # redirect_to tag_notes_path(@sharing.thingable)
    end
    flash[:notice] = "已個別發送通知給 #{mail_lists} 等人。"
    render :text => nil
  end

  def destroy
    @sharing = Sharing.find_by_token(params[:id])
    if @sharing.destroy
      if @sharing.owned?
        flash[:notice] = "已收回 #{@sharing.email} 的桌面共用。"
        render :text => nil
      else
        flash[:notice] = "已退出本桌面。您可隨時在通知欄裡重新啟用。"
        render :js => "window.location='/'"
      end
    end
    rescue Exception => exception
      flash[:notice] = exception.message
      render :nothing => true, :status => 500
  end
end

