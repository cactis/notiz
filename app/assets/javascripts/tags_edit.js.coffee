$(document).ready ->
  $('#tag_config_form :radio').change (e) ->
    $.ajax
      url: '/tags/' + Notiz.tags.current.id
      type: 'put'
      data:
        tag:
          float: $(e.target).attr('id').split('_').pop()
      success: (data, textStatus, jqXHR) ->
        $.fn.log 'radio change'
        $.ajax
          url: '/tags/' + Notiz.tags.current.id + '/notes'
          type: 'get'
          success: (data, textStatus, jqXHR) ->
            $('#content').html(data)
            $.fn.pageSetup()
            $.fn.initial_notes '#notes .post'

  $('#send_sharing_mail').click (e) ->
    $.fn.log $('#tag_sharing_mail_lists').val(), "$('#tag_sharing_mail_lists').val()"
    $mail_lists = $('#tag_sharing_mail_lists').val()
    $.fn.log $mail_lists
    return unless $mail_lists
    $.ajax
      url: '/sharings/'
      type: 'post'
      data:
        sharing:
          thingable_type: 'Tree'
          thingable_id: Notiz.tags.current.id
          mail_lists: $mail_lists
    false

  $('#tag_name')
    .keyup (e) ->
      $.fn.log 'tag_name keyup'
      $.fn.log $(e.target).val()
      $.fn.log Notiz.tags.current.id
      $('#tag_' + Notiz.tags.current.id).html($(e.target).val())

  $('#tag_config_form :text').blur (e) ->
    $this = $(e.target)
    $.fn.log $this.val(), 'this val'
    $.fn.log $this.data('old'), 'this data'
    if $this.val() == $this.data('old')
      return
    else
      $this.data 'old', $this.val()
    data = {}
    data[$this.attr('id').replace('tag_', '')] = $this.val()
    $.ajax
      url: '/tags/' + Notiz.tags.current.id
      type: 'put'
      data:
        tag: data

 $('.undo_naming').click (e) ->
    $target = $('#tag_' + Notiz.tags.current.id)
    $.ajax
      url: '/tags/' + Notiz.tags.current.id
      type: 'PUT'
      # contentType: 'josn'
      data:
        tag:
          name: ''
      success: (data, textStatus, jqXHR)->
        tag = data.tag
        $target.html(tag.name)
        $('#tag_name').val(tag.name)
      error: (xhr, ajaxOptions, thrownError) ->
    false

  $('.restore_wallpaper').click (e) ->
    if confirm '確定恢復原始桌布？'
      $.ajax
        url: '/tags/' + Notiz.tags.current.id
        type: 'PUT'
        data:
          tag:
            background: ''
        success:
          $('html').css 'background', ''
      false

