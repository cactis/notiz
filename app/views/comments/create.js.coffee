$("#<%= dom_id(@post) %>").find('form')[0].reset()
<%= broadcast "/#{@post.tag.token}/notes" do @comment.attributes.merge(:dom_id => dom_id(@post), :content => render(@comment)).to_json end %>

