# encoding: utf-8
class ArchivesController < ApplicationController
  def show
    if %w(tags notes).include?(params[:id])
      respond_to do |format|
        except = [:token, :tree_id, :tree_type, :options, :deleted_at, :parent_id, :lft, :rgt, :id, :user_id, :notes_list1]
        format.xml { render :xml => eval("#{params[:id].classify}.all.to_xml(:except => #{except})") }
        format.json { render :json => eval("#{params[:id].classify}.all.to_json(:except => #{except})") }
      end
    else
      render :text => "資料項目錯誤，無此種備份資料格式。"
    end
  end
end

