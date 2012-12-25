<%= broadcast "/#{@note.tag.token}/notes" do @msg end %>
# [:id, :subject, :body, :token, :options]
# $('#<%= dom_id(@note) %>').find('.v_num').html("<%= @note.versions.count %>")

