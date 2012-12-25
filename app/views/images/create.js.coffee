#content = "<img src='<%= picture_path(@asset, :size => :small)%>' style='width:<%=@asset.default_width%>px' />"
content = "<img src='<%= picture_path(@asset, :size => :small)%>' style='width:<%=@asset.default_width%>px; height:<%=@asset.default_height %>px' />"
#content = "<img src='<%= picture_path(@asset, :size => :small)%>'/>"
$.fn.add_post('clips', content)
$.fn.log '新增圖卡'
# $("<%= j render @asset %>").appendTo($("#attaches"))

