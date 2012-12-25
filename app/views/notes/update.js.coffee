<%= broadcast "/#{@note.tag.token}/notes" do @note.to_json(:only => @keys + [:id, :options]) end %>
# [:id, :subject, :body, :token, :options]
# $('#<%= dom_id(@note) %>').find('.v_num').html("<%= @note.versions.count %>")

