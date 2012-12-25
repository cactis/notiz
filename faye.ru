gem 'faye', '0.8.1'
require 'faye'
Faye::WebSocket.load_adapter 'thin'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => '/api', :timeout => 45)
faye_server.add_extension(ServerAuth.new)
run faye_server
