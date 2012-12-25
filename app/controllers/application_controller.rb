# -*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  #  after_filter :log_ram # or use after_filter
  #  def log_ram
  #    logger.warn '-' * 200
  #    logger.warn '------------------------------ RAM USAGE: ' + `pmap #{Process.pid} | tail -1`[10,40].strip + ' -----------------------------'
  #    logger.warn '-' * 200
  #  end

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  def record_not_found
    redirect_to root_url, :notice => '資料不存在，可能已被刪除。'
  end

  # layout :detect_browser
  before_filter :adjust_format, :except => [:create, :destroy]

  def notify(msg = flash[:notice])
    "$.jGrowl('#{msg}')"
  end
  helper_method :notify

  def after_sign_in_path_for(resource)
    # stored_location_for(resource) || root_path
    User.current = current_user
    tag_notes_path(current_user.tags.first)
  end

  after_filter :flash_headers
  def flash_headers
    if request.xhr?
      response.headers['x-flash'] = CGI.escape(flash[:error])  unless flash[:error].blank?
      response.headers['x-flash'] = CGI.escape(flash[:notice])  unless flash[:notice].blank?
      response.headers['x-flash'] = CGI.escape(flash[:warning])  unless flash[:warning].blank?
    else
      response.body << "<script>$.jGrowl('#{flash[:notice]}')</script>" unless flash[:notice].blank?
    end
    flash.discard
  end

  def supervisor?; current_user && current_user == User.first.order('id asc'); end; helper_method :supervisor?
  def subdomain; request.env["HTTP_HOST"].split('.')[0]; end; helper_method :subdomain

  before_filter :every_request
  def every_request
    debug request.path, 'request.path'
    debug 'params', params
    User.current = current_user if current_user
    if %w[stocks accounts assets sites units exam_items assessments assessment_responses].include?(current_path[0])
      authenticate_user!
    end

    case current_path[0]
    when "roles"
    when "sites"
      user_resources
    when "accounts"
      #debug 'current_site.users', current_site.users
      # current_site.users
    else
      site_resources
    end
  end

  def current_path
    #paths = request.env['REQUEST_URI'].split(/\/|\?|\&/)#.map{|s| s.split(/\=/)}
    paths = request.env['PATH_INFO'].split(/\/|\?|\&/)
    paths.delete('admin')
    paths.shift
    paths
  end
  helper_method :current_path

  def language
    language = request && request.env && request.env['HTTP_ACCEPT_LANGUAGE'] && request.env['HTTP_ACCEPT_LANGUAGE'].split(',')[0].downcase
    language = ['en', 'zh-tw'].include?(language) ? language.downcase : 'zh-tw'
    language
  end
  helper_method :language


  def current_site
    # Site.current
  end
  helper_method :current_site

  def development?
    Rails.env == 'development'
  end
  helper_method :development?

  def debug(*args)
    # return unless development?
    title ||= ""
    title += Time.now.to_s
    logger.debug "\n\n===== #{controller_name}/#{action_name} " + title + "=" * 50
    logger.debug args
    logger.debug "===== #{controller_name}/#{action_name} " + title + "=" * 50 + "\n\n"
  end
  helper_method :debug

  def user_agent; request.env['HTTP_USER_AGENT'];end
  helper_method :user_agent

MOBILE_BROWSERS = ["android", "iphone", "ipad", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  def mobile_device?
    agent = request.headers["HTTP_USER_AGENT"].downcase
    MOBILE_BROWSERS.each do |m|
      return true if  agent.match(m)
    end
    return false
  end
  private

  def adjust_format
    request.format = :mobile if mobile_device?
  end


  def site_resources
    if @routes = current_path[0] #units
      debug '@routes: ', @routes, 'current_path: ', current_path
      @route = @routes.singularize # unit
      # @klass = eval("current_site.#{@routes}") # current_site.units
    end
  end
end
