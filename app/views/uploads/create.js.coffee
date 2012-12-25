body = "<img src='<%= polymorphic_path(@asset, :size => :original) %>'/>"
$.fn.add_post('clips', body)

