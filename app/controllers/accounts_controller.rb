# encoding: utf-8
class AccountsController < ApplicationController
  respond_to :js, :html
  def edit
    # @account = User.find_by_token(params[:id])
    @account = current_user
    respond_with(@account) do |format|
      format.js{ render :layout => false, :content_type => :html }
    end
  end

  def update
    logger.ap params[:account]
    @account = current_user
    @account.update_attributes(params[:account])
    debug @account
    flash[:notice] = "用戶設定更新完成。"
    render :nothing => true
  end
end

