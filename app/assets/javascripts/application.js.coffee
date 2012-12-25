//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min


//= require colorbox/jquery.colorbox-min
//= require elastic/elastic

//= require colorpicker/js/colorpicker
//= require ColorJizz

//= require jgrowl/jquery.jgrowl_compressed

//= require modernizr

//= require jquery.scrollTo-1.4.2-min

//= require underscore-min

//= require jquery.tools.min

//= require jquery.hoverIntent.minified


//= require jquery.mousewheel
//= require mwheelIntent
//= require jquery_custom_scroller/jquery.mCustomScrollbar
//= require jquery_custom_scroller/jquery.mousewheel.min
//= require jquery_custom_scroller/jquery.easing.1.3

//= require inflection-js/inflection

//= require ember
//= require emberjs

//= require jquery.jrumble.1.3.min

//= require jquery.quickflip.min


//= require html5slider

//= require jquery.masonry.min
//= require modernizr.custom.71949

//= require common

#//// require Elastislide/jquery.elastislide

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


  $('.colorbox').colorbox({maxWidth: '85%', maxHeight: '85%', slideshow: true, slideshowSpeed: 10000})
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


jQuery.ajaxSetup
  beforeSend: ->
    $("body").prepend("<div id='loader'></div>")
    $("body").css "cursor", "progress"
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
      # $.fn.log flash
      #$.fn.log unescape(decodeURI(flash))
      $.jGrowl unescape(decodeURI(flash))

    # 設定所有 .close_30 的點擊行為
    # $('.close_30').unbind('click').click (e) ->
    $('.close_30').click (e) ->
      $(e.target).closest('.option').slideUp
        duration: 1000
        easing: 'easeInOutElastic'
      false
) jQuery
