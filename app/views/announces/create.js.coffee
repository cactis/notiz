<%= broadcast "/announces" do @announce.to_json(:only => [:subject]) end %>

