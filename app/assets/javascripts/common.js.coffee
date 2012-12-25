//= require jquery.timeago
//= require lib

(($) ->
  $.fn.developmentMode = ->
    true if window.location.hostname.match('.local')

  $.fn.log = (msg, hr)->
    if $.fn.developmentMode()
      console.log hr if hr && hr.length > 0
      console.log msg

  # 取得 dom_id 的 id 值
  $.fn.id = ->
    $(this).attr('id').split('_').pop() if $(this).attr('id')

  $.fn.set_external_link = ->
    $("a.external").each ->
      $(this).attr "target", "_blank"
    $("a[href^='http']").each ->
      $(this).attr "target", "_blank"  if @href.indexOf(location.hostname) == -1

  $.fn.clearSelection = ->
    sel = undefined
    if document.selection and document.selection.empty
      document.selection.empty()
    else if window.getSelection
      sel = window.getSelection()
      sel.removeAllRanges()  if sel and sel.removeAllRanges
) jQuery
