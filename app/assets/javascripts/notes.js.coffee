//= require notes_lib

mouseDown = false
min = 3
x = 0
y = 0
scrollLeft = 0
scrollTop = 0

offset_x = 0
offset_y = 0

$(document).ready ->
  $.fn.enableSortable($('.notes.float'))

$.ajaxSetup
  success: ->
    num = $('.post').length
    $('#num').html(num)

$.fn.add_post = (type, body) ->
  data = {}
  data[type.singularize()] = {}
  data[type.singularize()]["body"] = body
  $.ajax
    url: '/tags/' + Notiz.tags.current.id + '/' + type
    type: 'post'
    data: data
    success: (data, textStatus, jqXHR) ->
      $(data).hide().prependTo($("#notes")).fadeIn(1000)
      selector = '#' + $(data).attr('id')
      elm = $(selector)
      $.fn.initial_note(selector)
      Notiz.posts.setTop $(selector)
      if elm.hasClass('clip')
        elm.css 'width', elm.find('img').css('width')
        elm.css 'height', elm.find('img').css('height')
      if !Notiz.tags.current.float()
        elm.center()
        type = elm.attr('id').split('_')[0]
        data = {}
        data[type] = elm.position()
        $.ajax
          url: '/tags/' + Notiz.tags.current.id + '/' + type.pluralize() + '/' + $.fn.dom_id(elm)
          type: 'PUT'
          data: data
        success: ->
          if elm.hasClass('clip')
            elm.css 'width', elm.find('img').css('width')
            elm.css 'height', elm.find('img').css('height')
            $.fn.enable_resizable elm

(($) ->
  $.fn.initial_notes = (selectors) ->
    $(selectors).each ->
      $.fn.initial_note($(this))

  $.fn.initial_note = (selector) ->
    $post = $(selector)
    $post.find('.subject, .body').keydown (e) ->
      if 39 < e.keyCode < 112 || e.keyCode == 8 || e.keyCode == 13 || e.keyCode == 32 || e.keyCode == 46
        $('.dirty').addClass('true').data 'dirty-id', $(selector).id()
        Notiz.posts.current.area = if $(this).hasClass 'subject' then 'subject' else 'body'
      # ctrl-s or F2
      if ($('html').hasClass('ctrl') && e.keyCode == 83) || e.keyCode == 113
        $(e.target).trigger 'change'
        false

    $post
      .unbind('click').click (e) ->
        Notiz.posts.current.id = $(e.target).closest('.post').id()
      .find('.config').click (e) ->
        $.ajax
          url: '/tags/' + Notiz.tags.current.id + '/posts/' + $post.id() + '/edit'
          success: (data, textStatus, jqXHR) ->
            $post.find('.option .content').html(data)
            $post.find('.option').slideDown
              duration: 500
              easing: 'easeOutBounce'
        false
      .find('.edit').unbind('click').click (e) ->
        $editable = $(e.target).closest('.post').find('[contenteditable]')
        $editable.trigger 'change'

    $post
      .find('.open_comments').unbind('click').click (e) ->
        $.ajax
          url: '/posts/' + $post.id() + '/comments'
          success: (data, textStatus, jqXHR) ->
            $post.find('.comments').hide().html($(data)).slideDown
              duration: 1000
              easing: 'easeOutBounce'
            $post.find('.content').scrollTo 'max'
            $post.find('.comments .close_30').click (e) ->
              $(e.target).closest('.comments').slideUp
                duration: 1000
                easing: 'easeOutBounce'
            $post.find('textarea').focus()
            $post.find('.comments').mousedown ->
              $post.filter(':ui-draggable').draggable('destroy')
              $('#notes').filter(':ui-sortable').sortable('destroy')
        false

    # 設定前景色
    $.fn.setColor $post.find('.subject')
    $.fn.setColor $post.find('.body')

    # 手動排版模式的行為
    $('.absolute').find(selector)
      # 拖拉時的定位
      .hover ->
        type = if $(selector).hasClass('clip') then 'clips' else 'notes'
        # console.log(type)
        $this = $(this)
        $this.draggable
          delay: 100
          start: (e, ui) ->
            Notiz.posts.setTop $this
            $this.addClass('dragging')
          stop: (e, ui) ->
            data = {}
            data[type.singularize()] = {}
            data[type.singularize()] = $this.position()
            $.ajax
              url: '/' + type + '/' + $.fn.dom_id($this)
              type: 'PUT'
              data: data
      .click ->
        $.fn.log '第一下點擊：貼紙取得焦點'
        $this = $(this)
        Notiz.posts.setTop $this
        if $this.hasClass('dragging')
          $this.removeClass('dragging')
        else
          $this.filter(':ui-draggable').draggable('destroy')

    elm = $(selector)
    $.fn.note_resize_body(elm, '.body')

    elm
      # 控制工具列跟游標
      .mouseenter ->
        $.fn.enableSortable($('.notes.float'))
        $(this).find('.toolbar').addClass('visible')
        $(this).find('.subject, .body, img').css('cursor', 'move')
      .mouseleave ->
        $(this).find('.toolbar').removeClass('visible')

      # 進入編輯模式，同時駟動先前的編輯儲存
      .click ->
        $.fn.log '第二下點擊：進入編輯模式，同時駟動先前的編輯儲存'
        $.fn.saveNote()
        if $(this).hasClass('dragging')
          $(this).removeClass('dragging')
        else
          $('.notes').filter(':ui-sortable').sortable('destroy')

      .find('.subject, .body').click (e) ->
        if $(e.target).hasClass('subject')
          Notiz.posts.current.area = 'subject'
        else
          Notiz.posts.current.area = 'body'
        # 移入 Notiz 物件
        # $('[contenteditable]').attr 'contenteditable', false
        # $(this).attr('contenteditable', true).css 'cursor', 'text'
        Notiz.posts.startEdit($(this).closest('.post'))
      # 控制遊標移動時，貼紙上下層行為
      .hoverIntent
        over: ->
          # $.fn.log 'hover to top begin!'
        timeout: 5000
        out: ->
          # $.fn.log 'hover to top end!'

    # toolbar setup
    $.fn.version_handler(elm, '.undo')
    $.fn.note_color_picker(elm, 'subject_background') if elm.hasClass('note')
    $.fn.note_color_picker(elm, 'body_background') if elm.hasClass('note')
    $.fn.note_contenteditable(elm)
    $.fn.enable_resizable(elm)

  $.fn.enableSortable = (elm) ->
    elm.sortable
      items: '.post'
      delay: 100
      cursor: 'move'
      start: (e, ui) ->
        $(e.target).addClass('dragging')
      stop: (e, ui) ->
        $(e.target).removeClass('dragging')
      update: (e, ui) ->
        Notiz.posts.setTop $(e.target)


  # 針對 note 及 clip 的不同調整大小
  # note 無比例關係，clip 有比例關係
  $.fn.enable_resizable = (elm) ->
    if elm.hasClass('clip')
      elm.find('img').width elm.width() + 'px'
      elm.find('img').height elm.height() + 'px'
      elm
        .resizable
          autoHide: true
          #handles: 'all'
          minWidth: "60"
          # alsoResize: elm.find('.body')
          aspectRatio: true
          stop: (e, i) ->
            id = $(this).attr('id').split('_')[1]
            width = $(this).width()
            height = $(this).height()
            body = "<img src='" + $(this).find('img').attr('src') + "'/>"
            $.ajax
              url: '/clips/' + id
              type: 'PUT'
              data:
                clip:
                  width: width
                  height: height
                  body: body
        .resize ->
          $.fn.note_resize_body($(this), 'img')
          $width = $(this).width()
          $size = 'small'
          $size = 'thumb' if $width < 128
          $size = 'medium' if $width >= 256
          $size = 'large' if $width >= 512
          $size = 'original' if $width >= 1024
          $img = $(this).find('img')
          $src = $img.attr('src').replace(/\/images\/.*\//, '/images/' + $size + '/')
          $img.attr('src', $src)

    else
      elm
        .resizable
          autoHide: true
          minWidth: "200"
          minHeight: "50"
          start: (e, i) ->
            # $(e.target).closest('.note').find('[contenteditable]').trigger 'change'
          stop: (e, i) ->
            id = $(this).attr('id').split('_')[1]
            note = {}
            note.width = $(this).width()
            note.height = $(this).height()
            if $('.dirty.true').length > 0
              note.subject = $(this).find('.subject').html()
              note.body = $(this).find('.body').html()
              $('.dirty.true').removeClass('true')
            $.ajax
              url: '/notes/' + id
              type: 'PUT'
              data:
                note: note
        # 配合貼紙大小，即時調整 body 高度
        .resize ->
          $.fn.note_resize_body($(this), '.body')


) jQuery
