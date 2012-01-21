# vim: ts=2 sw=2 et :
class Background
  constructor: (@dom, @manager)->

  dispatchEvent: ()->
    evt = document.createEvent('Event');
    evt.initEvent('backgroundTransitioned', false, false);
    evt.background = this;
    slide = @manager.getCurrent();
    slide.dom.dispatchEvent(evt);

window.Background = Background

