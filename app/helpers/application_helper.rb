# -*- encoding: utf-8 -*-

module ApplicationHelper
  include MobileConcerns::Helpers

  def about(obj)
    %Q(
        作者: #{obj.user.name}, 更新:
        <abbr class='timeago' title="#{obj.updated_at}"></abbr>
        , 建立:
        <abbr class='timeago' title="#{obj.created_at}"></abbr>
    ).html_safe
  end

  def broadcast(channel, token = nil, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    debug message, 'message'
    uri = URI.parse("#{APP[:url]}:9292/api")
    # debug uri, 'uri'
    # debug message.to_json, 'message.to_json'
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def link_to_oauth_login(provider)
    # "<a href='#{user_oauth_authorize_url(:facebook)}' class='oauth_login Facebook'>以facebook登入</a>".html_safe
    case provider
    when :facebook
      link_to(image_tag("facebook_48x48.png"), user_omniauth_authorize_path(provider), :class => "oauth_login facebook", :title => 'Sign in by Facebook account')
    when :yahoo
      # link_to "Sign in with Yahoo", user_omniauth_authorize_path(:open_id, :openid_url => "http://yahoo.com"), :class => 'yahoo'
      link_to "sign in with yahoo", user_omniauth_authorize_path(:yahoo)#, :openid_url => "http://yahoo.com")
    when :google_apps
      link_to image_tag("google_48x48.png"), user_omniauth_authorize_path(:google_apps), :class => 'oauth_login google', :title => 'Sign in by Google account'
    when :twitter
      link_to "Sign in with Twitter", user_omniauth_authorize_path(:twitter), :class => 'twitter'
    end
  end

  def author_tools(obj)
    return unless can_edit?(obj)
    [link_to_edit(obj), link_to_snippet_lib(obj), link_to_delete(obj), link_to_rescue(obj)].compact.map{|tool| "[#{tool}]"}.join.html_safe
  end

  def link_to_delete(obj)
    return unless can_edit?(obj)
    link_to "delete", polymorphic_path(obj), :method => :delete, :confirm => "delete it?"
  end

  def link_to_edit(obj, options = {})
    return if action_name == 'edit'
    return unless can_edit?(obj)
    link_to "edit", polymorphic_path([:edit, obj])
  end


  def list_attributes(obj)
    if obj.is_a?(Array)
      obj.map{|o|
        alist_attributes(o)
      }.join
    else
      alist_attributes(obj)
    end.html_safe
  end

  def alist_attributes(obj)
    "<h1>#{obj.title}</h1>" +
    "<dl>" +
    obj.attributes.map{|key, value| "<dt>#{key}</dt><dd>#{value}</dd>"}.join +
    "</dl>"
  end

  #  def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
  #    require 'cgi'
  #    CGI.unescapeHTML(CGI.unescapeHTML(super))
  #  end

  #  def link_to(*args, &block)
  #    require 'cgi'
  #    CGI.unescapeHTML(CGI.unescapeHTML(super))
  #  end
end

