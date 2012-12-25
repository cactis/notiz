<%= broadcast "/#{@clip.tag.token}/notes" do @clip.to_json(:only => [:id, :token, :body, :options]) end %>

