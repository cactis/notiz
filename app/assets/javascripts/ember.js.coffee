#window.Notiz = Ember.Application.create
window.Notiz =
  tags:
    list: $('.tag')
    current:
      id: window.location.pathname.split('/')[2]
      float: ->
        # $.fn.log $('#tag_' + Notiz.tags.current.id).hasClass('float'), 'current tag mode'
        return $('#notes').hasClass('float')
  posts:
    list: []
    topZindex: 0
    listStr: ->
      this.list.join(',')
    setTop: (elm) ->
      # setTop 本身就負責寫入更新的動作
      if Notiz.tags.current.float()
        Notiz.posts.initList()
      else
        # $.fn.log elm.id()
        # $.fn.log this.list[0]
        return if elm.id() == this.list[0]
        elm.css 'z-index', this.topZindex
        this.topZindex += 1
        this.list = _.without(this.list, elm.id())
        if Notiz.tags.current.float()
          this.list.push(elm.id())
          this.list = this.list
        else
          this.list = this.list.reverse()
          this.list.push(elm.id())
          this.list = this.list.reverse()
      # $.fn.log this.list
      $.ajax
        url: '/tags/' + Notiz.tags.current.id
        type: 'PUT'
        data:
          tag:
            notes_list: this.listStr()
    initList: ->
      l = []
      $('.post').each ->
        # Notiz.posts.setTop $(this) if !Notiz.tags.current.float()
        l.push $(this).id()
      this.list = l
      # $.fn.log 'Notiz.posts.list: ' + Notiz.posts.list
    current:
      id: undefined
      area: ''
      timestamping: Date.now()
    startEdit: (elm) ->
      this.endEdit()
      id = elm.id()
      return if id == this.current.id
      this.current.id = id
      $selector = "#note_" + id
      $this = $($selector)
      $('[contenteditable]').attr 'contenteditable', false
      $this.find('.subject, .body').attr('contenteditable', true).css 'cursor', 'text'
      # $.fn.log id + ' begin....'

    endEdit: -> #(elm) ->
      # $.fn.log this.current
      return if this.current.id == 'undefined'
      id = this.current.id
      $selector = "#note_" + id
      $this = $($selector)
      $('[contenteditable]').toggleClass('contenteditable').removeAttr('contenteditable')
      this.current.id = undefined
      # $.fn.log id + ' end...'
