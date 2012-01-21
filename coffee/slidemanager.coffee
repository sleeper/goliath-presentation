# vim: ts=2 sw=2 et :
class SlideManager
  constructor: () ->
    @util = new Util
    @slides = []
    @backgrounds = {}
    domslides = document.querySelectorAll('.slide')
    dombgds = document.querySelectorAll('.background')
    @domStage = document.querySelector('#stage')
    @domContent = document.querySelector('#content')
    @domBackground = document.querySelector('#background')
    @bgDefault = 'bg-white';

    idx = 0
    for s in domslides
      @slides.push new Slide(s, this, idx, @util)
      idx += 1

    idx = 0
    for b in dombgds
      @backgrounds[b.id] = new Background(b, this)

    @init_events()
    @init_slide_in()
    @parse_history()

  next: ()->
    @setCurrent( @current + 1 )

  prev: ()->
    @setCurrent( @current - 1)

  init_events: () ->
    window.addEventListener 'keydown', @on_key_down.bind(this), false

  on_key_down: (evt) ->
    switch evt.keyCode
      when 37 then @prev()
      when 32, 39 then @next()

  init_slide_in: ()->
    # Let's ensure that each slide will receive a slideIn event
    for s in @slides
      s.addEventListener 'slideIn', @onSlideIn.bind(this), false

    # Let's ensure that 'slide-in' slide will have the right
    # events handler
    slides = document.querySelectorAll('.slide-in')
    for s in slides
      s.classList.add('off')
      s.addEventListener 'slideIn', () ->
        s.classList.remove('off')
      , false
      s.addEventListener 'slideOut', ()->
        s.classList.add('off')
      , false

  onSlideIn: (evt)->
    @setBackground(@getBackgroundId(evt.slide.index));
#    @domOverlay.style.opacity = 0;

  parse_history: ()->
    parts = window.location.href.split('#')
    @current = 0
    if parts.length == 2
      @current = parseInt(parts[1])-1;
    @setCurrent( @current )
    @getCurrent().dispatchEvent();


  setCurrent: (idx)->
    @current = idx
    @setHistory( idx )
    i = 0
    for s in @slides
      s.setCurrentOffset(i - idx)
      i += 1

  getCurrent: ()->
    @slides[@current]

  setHistory: (idx)->
    path = window.location.pathname + '#' + (idx+1)
    window.history.pushState({}, null, path)

  setBackground: (id)->
    current = @backgrounds['active']
    next = @backgrounds[id];
    if (current != next)
      last = @backgrounds['last']
      if (last)
        last.dom.classList.remove('last')
        @domContent.appendChild(last.dom)
        @backgrounds['last'] = null

      if (current)
        current.dom.classList.add('last')
        @backgrounds['last'] = current
        current.dom.classList.remove('active')
        @backgrounds['active'] = null

      if (next)
        @backgrounds['active'] = next
        @domBackground.appendChild(next.dom)
        window.setTimeout ()->
          next.dom.classList.add('active')
        , 0
    else
      next.dispatchEvent()

  # Get the backgroundid of the slide 'idx'
  # or the first one found before
  # or even the default one
  getBackgroundId: (idx)->
    i = idx
    bgid = null
    while !(bgid = @slides[i].getBackgroundId()) && i>=0
      i -= 1

    return bgid || @bgDefault

new SlideManager

