class TestsController < ApplicationController
  def index
    respond_to do |format|
      format.html{
        debug 'hhhhhhhhhhhhhhhhhhhhhh'
      }
      format.js{
        debug 'jjjjjjjjjjjjjjjavascript'
        render :json => Tag.first
      }
      format.json{
        debug 'jjjjjjjjjjjjjjjjjjjson'
        render :json => Tag.first
      }
    end
  end

  def show
    respond_to do |format|
#      format.html{
#        debug 'hhhhhhhhhhhhhhhhhhhhhh'
#        render :json => Tag.first
#      }
      format.js{
        debug 'jjjjjjjjjjjjjjjavascript'
        render :json => Tag.first
      }
      format.json{
        debug 'jjjjjjjjjjjjjjjjjjjson'
        render :json => Tag.first
      }
    end
  end
end

# Content-Type	text/javascript; charset=utf-8

