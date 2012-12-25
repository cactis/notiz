#$(document).ready ->
#  $("#test").click ->
#    console.log 'abc'
#    $.ajax
#      'http://test.168ecard.com/e168/pub/html/choose.php'
#      crossDomain: true
#      dataType: 'jsonp'
#      success: (data, textStatus, jqXHR) ->
#        console.log data
#      error:
#        console.log 'error'

$(document).ready ->
  $(".first.current").click ->
    $.ajax 'http://test.168ecard.com/e168/pub/html/choose.php'
      crossDomain: true
      dataType: 'jsonp'

      success: (data, textStatus, jqXHR) ->
        # console.log data
      error: (xhr, ajaxOptions, thrownError) ->
        # console.log xhr
        # console.log ajaxOptions
        # console.log thrownError

#$(document).ready ->
#  $("#test").click ->
#    console.log 'abc'
#    $.ajax
#      url: '/tests/3'
#      dataType: 'json'
#      success: (data, textStatus, jqXHR) ->
#        console.log data
#      error: (xhr, ajaxOptions, thrownError) ->
#        console.log xhr
#        console.log ajaxOptions
#        console.log thrownError
# url: 'http://test.168ecard.com/e168/pub/html/choose.php'

