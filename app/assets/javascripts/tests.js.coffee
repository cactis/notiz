$(document).ready ->
  $(".first.current").click ->
    $.ajax 'http://test.168ecard.com/e168/pub/html/choose.php'
      crossDomain: true
      dataType: 'jsonp'

      success: (data, textStatus, jqXHR) ->
      error: (xhr, ajaxOptions, thrownError) ->
