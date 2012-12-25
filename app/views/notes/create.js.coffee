# $("<%= j render(@note) %>").hide().prependTo($("#content #notes")).fadeIn(500)
#$(document).ready ->
#  $.fn.enable_note($("#<%= dom_id(@note) %>"))

# 不需重覆設定，因為 .notes 已設定，但是 absolute 模式需要執行
# $.fn.notes_draggable($("#<%= dom_id(@note) %>"))

