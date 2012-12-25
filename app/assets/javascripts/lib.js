jQuery.timeago.settings.strings = {
  prefixAgo: null,
  prefixFromNow: "從現在開始",
  joinWith: '',
  suffixAgo: "前",
  suffixFromNow: null,
  seconds: "不到1分鐘",
  minute: "1分鐘",
  minutes: "%d分鐘",
  hour: "1小時",
  hours: "%d小時",
  day: "1天",
  days: "%d天",
  month: "1個月",
  months: "%d月",
  year: "1年",
  years: "%d年",
  numbers: []
};


function rgbtohex (rgbString){
  var rgbString = "rgb(0, 70, 255)"; // get this in whatever way.
  var parts = rgbString.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
  // parts now should be ["rgb(0, 70, 255", "0", "70", "255"]

  delete (parts[0]);
  for (var i = 1; i <= 3; ++i) {
    parts[i] = parseInt(parts[i]).toString(16);
    if (parts[i].length == 1) parts[i] = '0' + parts[i];
  }
  var hexString = parts.join(''); // "0070ff"
  return hexString;
}


$.fn.getHexBackgroundColor = function(elm) {
    var rgb = elm.css('background-color');
    if (!rgb) {
        return '#FFFFFF'; //default color
    }
    var hex_rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
    if (hex_rgb) {
        return "#" + hex(hex_rgb[1]) + hex(hex_rgb[2]) + hex(hex_rgb[3]);
    } else {
        return rgb; //ie8 returns background-color in hex format then it will make                 compatible, you can improve it checking if format is in hexadecimal
    }
}

$.fn.dom_id = function(elm){
  return elm.attr('id').split('_')[1];
}

function unescapeHTML(html) {
   var htmlNode = document.createElement("DIV");
   htmlNode.innerHTML = html;
   if(htmlNode.innerText !== undefined)
      return htmlNode.innerText; // IE
   return htmlNode.textContent; // FF
}

function isScrolledIntoView(elem)
{
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return ((elemBottom >= docViewTop) && (elemTop <= docViewBottom));
}

//$('textarea').keyup(function (event) {
//   if (event.keyCode == 13 && event.shiftKey) {
//       var content = this.value;
//       var caret = getCaret(this);
//       this.value = content.substring(0,caret)+
//                     "\n"+content.substring(carent,content.length-1);
//       event.stopPropagation();

//  }
// });

