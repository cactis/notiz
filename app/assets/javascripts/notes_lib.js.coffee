$.fn.floatStatus = ->
  Notiz.tags.current.float()

# 取得視窗中正位置
$.fn.center = ->
  @css "position", "absolute"
  @css "top", (($(window).height() - @outerHeight()) / 2) + $(window).scrollTop() + "px"
  @css "left", (($(window).width() - @outerWidth()) / 2) + $(window).scrollLeft() + "px"
  this

# 放入事件，取得滑鼠座標
mouse_position = (e) ->
  posx = 0
  posy = 0
  e = window.event  unless e
  if e.pageX or e.pageY
    posx = e.pageX
    posy = e.pageY
  else if e.clientX or e.clientY
    posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
  return [posx, posy]

# 版本控制器
$.fn.version_handler = (elm, selector) ->
  elm.find(selector)
    .click ->
      $this = $(this)
      $toolbar = $this.closest('.toolbar')
      $note = $this.closest('.note')
      version_id = -1
      last_version_id = -1

      if $this.data('version_id') == undefined
        $this.data 'version_id', version_id
      else
        version_id = parseInt($this.data('version_id'))
      $.ajax
        url: '/notes/' + $.fn.dom_id($note) + '/versions'
        data:
          version_id: version_id
        success: (data, textStatus, jqXHR) ->
          $data = $(data)
          if $note.find('.version')
            $note.find('.version').detach()
          $data.appendTo($toolbar)
          last_version_id = parseInt($data.find('.num').html()) * -1
          $this.data 'last_version_id', last_version_id
          if version_id > last_version_id
            $this.data 'version_id', version_id - 1
          else
            $this.data 'version_id', -1

      false

# 給定對象，判別底色，設定 .toolbar 及 body 的前景色
$.fn.setColor = (elm) ->
  # $.fn.log elm
  # $.fn.log elm.closest('.post').hasClass 'nnote'
  return false if elm.closest('.post').hasClass 'nnote'
  # $.fn.log Notiz.posts.current.area
  $bg = $.fn.getHexBackgroundColor(elm)
  $bg = new Hex('0x' + $bg.replace('#', ''))
  $fg = $bg.sweetspot(true)[4]#.brightness(0.5)
  elm.css('color', '#' + $fg)


# 色彩選擇器設定函數
$.fn.note_color_picker1 = (elm, area)->
  $picker = elm.find('.background_picker')
  if area == 'subject'
    $target = elm.find('.subject')
    $attr = 'subject_background'
  else
    $target = elm
    $attr = 'body_background'
  $picker.ColorPicker
    onBeforeShow: ->
      $bg = $.fn.getHexBackgroundColor($target)
      $(this).ColorPickerSetColor($bg)
    onChange: (hsb, hex, rgb) ->
      $color = '#' + hex
      $target.css 'background', $color
      $.fn.setColor($target)
    onHide: (hsb, hex, rgb, el) ->
      $note = {}
      $note[$attr] = $.fn.getHexBackgroundColor($target)
      $.ajax
        url: '/notes/' + Notiz.posts.current.id
        type: 'PUT'
        data:
          note: $note
        success: ->
          # $.fn.log 'unbind colorpicker'
          # $.fn.log $picker.unbind 'ColorPicker'


# 色彩選擇器設定函數
$.fn.note_color_picker = (elm, attribute)->
  $picker = elm.find('.' + attribute)
  $attr = ''
  $id = elm.id()
  if attribute == 'subject_background'
    $target = elm.find('.subject')
    $attr = 'subject_background'
  else
    $target = elm.find('.body')
    $attr = 'body_background'
  $picker.ColorPicker
    onBeforeShow: ->
      $bg = $.fn.getHexBackgroundColor($target)
      $(this).ColorPickerSetColor($bg)
    onChange: (hsb, hex, rgb) ->
      # $.fn.log Notiz.posts.current.area
      $color = '#' + hex
      $target.css 'background', $color
      $.fn.setColor($target)
    onHide: (hsb, hex, rgb, el) ->
      $note = {}
      $note[$attr] = $.fn.getHexBackgroundColor($target)
      $.ajax
        url: '/notes/' + $id
        type: 'PUT'
        data:
          note: $note


# 大小調整函數
$.fn.note_resize_body = (elm, selector) ->
  if elm.hasClass('clip')
    elm.find(selector).width elm.width() + 'px'
    elm.find(selector).height elm.height() + 'px'
  else
    note_height = elm.height()
    $subject = elm.find('.subject')
    subject_height = $subject.height()
    num = if Notiz.tags.current.float() then subject_height + 20 else 15
    if Notiz.tags.current.float()
      num = subject_height + parseInt(elm.css('padding-top').replace('px', '')) + parseInt(elm.css('padding-bottom').replace('px', '')) + 5
    else
      num = subject_height + parseInt(elm.css('padding-top').replace('px', '')) + parseInt(elm.css('padding-bottom').replace('px', '')) - 22
    # $.fn.log num, 'num'
    elm.find(selector).height((note_height - num) + 'px')

$.fn.note_contenteditable = (elm) ->
  elm.find("[contenteditable]")
    .live "focus", ->
      $(this).closest('.note').toggleClass('focus')
    .live "blur", -> #keyup paste
      $(this).closest('.note').toggleClass('focus')
      $(this).trigger "change"
      if $(this).data("before") isnt $(this).html()
        $(this).data "before", $(this).html()
        $(this).trigger "change"
    .live 'change', ->
      $.fn.saveNote()

$.fn.saveNote = ->
  # $.fn.log Notiz
  # $.fn.log Date.now()
  if $('.dirty.true').length > 0
    id = $('.dirty').data 'dirty-id'
    content = $("#note_" + id).find('.' + Notiz.posts.current.area).html() #$(this).html() #data('before')
    data = {}
    data['note'] = {}
    data['note'][Notiz.posts.current.area] = content
    data['note']['timestamping'] = Notiz.posts.current.timestamping
    $.ajax
      url: '/notes/' + id
      type: 'PUT'
      data: data
      success:
        $('.dirty').removeClass('true')
    false
