#$(document).ready ->
#  $.fn.notes_draggable()

##$(document).ready ->
#  $('.draggable')
#    .mousedown (e) ->
#      $(this).closest('.note').draggable
#        containment: 'parent'
#        stop: (e, ui) ->
#          console.log(e)
#    .mouseup (e) ->
#      $(this).closest('.note').draggable('destroy')


#$(document).ready ->
#  $('.note')
#    .sortable
#      items: 'div'
#      delay: 1500
#      axis: 'x'
#      cursor: 'move'
#      start: (e, ui) ->
#      stop: (e, ui) ->
#        list = []
#        $(this).find('.tag').each ->
#          list.push $(this).attr('id').split('_')[1]
#        $.ajax
#          url: '/tags/#{params[:id]}'
#          type: 'put'
#          data:
#            user:
#              tags_list: list.join(',')

