//= require jquery
//= require jquery.ui.all
//= require jquery_ujs

//= require jquery-migrate-1.1.1

//= require colorbox/jquery.colorbox-min
//= require elastic/elastic

#// require colorpicker/js/colorpicker
//= require ColorJizz

#// require jgrowl/jquery.jgrowl

#//= _require modernizr

//= require jquery.scrollTo-1.4.2-min

//= require underscore-min


//= require jquery.tools.min.1.2.7

//= require jquery.hoverIntent.minified




#//= _require jquery.mousewheel
#//= _require mwheelIntent
#//= _require jquery_custom_scroller/jquery.mCustomScrollbar
#//= _require jquery_custom_scroller/jquery.mousewheel.min
#//= _require jquery_custom_scroller/jquery.easing.1.3

//= require inflection-js/inflection

//= require variables

#//= _require jquery.jrumble.1.3.min

#//= _require jquery.quickflip.min

#//= _require html5slider

#//= _require jquery.masonry.min
# // require modernizr.custom.71949
//= require modernizr.custom.2.6.2

//= require common

#//= _require Elastislide/jquery.elastislide

$(document).ready ->
  $('abbr.timeago').timeago()
  $(':required').blur (e) ->
    # $.fn.log 'required blur'
    $this = $(e.target)
    if !$this.val()
      $.jGrowl('本欄位不能空白。')
      $this.focus()
      false

  $('.config').click ->
    $.fn.slideUpOption()

  $("#user_config").click (e) ->
    $.ajax
      url: '/accounts/' + $('#current_user').data('token') + '/edit'
      success: (data, textStatus, jqXHR) ->
        $("#user_config_form").detach()
        $(data).hide().insertAfter($(e.target)).slideDown
          duration: 1000
          easing: 'easeOutBounce'

        # $.fn.log $(data)
    false

  #  $('html').click ->
  #    $('.visible').removeClass('visible')
  #    $.fn.slideUpOption()

  $('.tag .toolbar a').click ->
    $('.tag .toolbar').removeClass('visible')



  $.fn.set_external_link()

  # $.fn.enable_note($('.note'))

  $(document)
    .keydown (e) ->
      # $.fn.log e.keyCode
      switch e.keyCode
        when 17
          $('html').addClass('ctrl')
        when 16
          $('html').addClass('shift')

      if $('html').hasClass('ctrl')
        switch e.keyCode
          when 18
            Notiz.posts.endEdit #$(e.target).closest('.note')

      if !$('html').hasClass('shift')
        switch e.keyCode
          when 13
            if $(e.target).closest('.comments').length > 0
              $(e.target).closest('form').submit()
              false

    .keyup (e) ->
      $('html').removeClass('ctrl').removeClass('shift')
      if( e.keyCode == 17)
        # $('.contenteditable').toggleClass('contenteditable').attr('contenteditable', '')
        Notiz.posts.startEdit $(e.target).closest('.note') if $(e.target).closest('.note').length > 0


(($) ->

  $.fn.slideUpOption = ->
    $.fn.slideUpObj $('.option')
    # $('.option .content').html('')

  $.fn.slideUpObj = (elm) ->
    elm.slideUp
      duration: 500
      easing: 'easeInOutElastic'
      ->
        $('.option').detach()
) jQuery

$.delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

$.jGrowl = (msg) ->
  $notice = $('#notice')
  $notice.html(msg).fadeIn(300)
  $.delay ->
    $notice.fadeOut(300)
  , 3000


jQuery.ajaxSetup
  beforeSend: (xhr) ->
    $("body").prepend("<div id='loader'></div>")
    $("body").css "cursor", "progress"
    xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")

    # $.fn.log 'ajax callback: beforesend'

  complete: (jqXHR, textStatus) ->
    # $.fn.log 'ajax callback: complete'
    # $.fn.log jqXHR, 'jqXHR'
    # $.fn.log textStatus, 'textStatus'
    $.fn.ajax_reset jqXHR, textStatus

  success: (data, textStatus, jqXHR) ->
    # $.fn.log 'ajax callback: success'
    $.fn.ajax_reset jqXHR, textStatus

  error: (jqXHR, ajaxOptions, thrownError) ->
    # $.fn.log 'ajax callback: error'
    # $.fn.log jqXHR
    # $.fn.log ajaxOptions
    # $.fn.ajax_reset jqXHR, thrownError
    # $.jGrowl ajaxOptions if ajaxOptions.length > 0

(($) ->
  $.fn.ajax_reset = (jqXHR, textStatus) ->
    $("#loader").remove()
    $("body").css("cursor", "pointer");
    $('.colorbox').colorbox()
    $('abbr.timeago').timeago()
    if jqXHR && flash = jqXHR.getResponseHeader 'x-flash'
      $.jGrowl unescape(decodeURI(flash))

    # 設定所有 .close_30 的點擊行為
    # $('.close_30').unbind('click').click (e) ->
    $('.close_30').click (e) ->
      $(e.target).closest('.option').slideUp
        duration: 1000
        easing: 'easeInOutElastic'
      false
) jQuery
