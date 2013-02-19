//= require colorbox/jquery.colorbox-min
//= require file_upload

$(document).ready ->
  $('.colorbox').colorbox({maxWidth: '85%', maxHeight: '85%', slideshow: true, slideshowSpeed: 10000})
  # 由於有多次載入的問題，桌面物件的基本設定要在這裡完成
  $.fn.pageSetup()
  $.fn.next_page(2)
  Notiz.posts.initList()
  $.fn.auto_open_comments()
  $.fn.tag_tools_config_bind_cick()

  $('#add_note').click ->
    $.fn.add_post('notes', '')
    false

  window.onbeforeunload = ->
    if $('.dirty.true').length > 0
      return "尚有未儲存的資料，要關閉?"



$.fn.next_page = (page)->
  return if page > gon.num_pages
  $.ajax
    url: document.URL
    data:
      page: page
    success: (data, textStatus, jqXHR) ->
      $(data).appendTo($("#notes"))
      $.fn.pageSetup()
      $("#num").html($("#notes .post").length)

      $.fn.next_page(page + 1)
      $.fn.auto_open_comments()
    error: ->
      false

$.fn.auto_open_comments = ->
  # 開啟留言通知返回的留言板
  $hash = window.location.hash
  $target = $($hash)
  setTimeout ->
    if $hash
      window.location.hash = $hash
      $target.find('.open_comments').trigger 'click' if !$target.find('.comments').html()
      800
      $target.css 'z-index', 999

$.fn.pageSetup = ->
  $('.clip img').each ->
    src = $(this).attr('src')
    href = src.replace('/small/', '/large/').replace('/medium/', '/large/').replace('/thumb/', '/large/')
    $(this).closest('a').attr('href', href)


$.fn.tag_tools_config_bind_cick = ->
  $('#tag_tools .config').unbind('click').click (e) ->
    $.ajax
      url: '/tags/' + Notiz.tags.current.id + '/edit'
      success: (data, textStatus, jqXHR) ->
        $("#tag_config_form").detach()
        $(data).hide().insertAfter($(e.target)).slideDown
          duration: 1000
          easing: 'easeOutBounce'
    false
