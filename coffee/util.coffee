# vim: ts=2 sw=2 et :
class Util
  constructor: ()->
    @ua = navigator.userAgent
    @isFF = parseFloat(@ua.split("Firefox/")[1]) || undefined;
    @isWK = parseFloat(@ua.split("WebKit/")[1]) || undefined;
    @isOpera = parseFloat(@ua.split("Opera/")[1]) || undefined;
    @transitionEnd = if @isWK
        "webkitTransitionEnd" 
      else 
        if @isFF
          "transitionend"
        else 
          "OTransitionEnd"


window.Util = Util

