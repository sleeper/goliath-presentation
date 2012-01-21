# vim: ts=2 sw=2 et :
class Slide
  constructor: (@dom, @manager, @index, @util) ->
    styles = window.getComputedStyle(dom, null)
    transitionProps = styles.getPropertyValue('-webkit-transition-property') ||
                      styles.getPropertyValue('-moz-transition-property')
    @transitionPropertyCount = transitionProps.split(',').length
    onTransition = @onTransition.bind(this)
    @dom.addEventListener(@util.transitionEnd, onTransition, false)
    @dom.addEventListener('backgroundTransitioned', @onBackground, false)

  onTransition: (evt)->
    if (evt.target == @dom)
      @transitionFinishedCount += 1 
      if (@transitionFinishedCount >= @transitionPropertyCount)
        @dispatchEvent()

  onBackground:()->

  setCurrentOffset: (offset)->
    # We need to set class only for the 2 slides
    # before and after the current slide
    if Math.abs(offset) <= 2
      if @dom.parentNode != @manager.domStage
        @manager.domStage.appendChild( @dom )

      @setClassIf( offset == -2, 'far-past' )
      @setClassIf( offset == -1, 'past' )
      @setClassIf( offset == 0, 'current' )
      @setClassIf( offset == 1, 'future' )
      @setClassIf( offset == 2, 'far-future' )
    else
      if @dom.parentNode != @manager.domContent
        @manager.domContent.appendChild( @dom )
    @transitionFinishedCount = 0

  dispatchEvent: ()->
    evt = document.createEvent('Event')
    evt.slide = this
    if (@dom.classList.contains('current'))
      evt.initEvent('slideIn', false, false)
    else
      evt.initEvent('slideOut', false, false)
    @dom.dispatchEvent(evt)

  setClassIf: (cond, name)->
    if cond
      @dom.classList.add name
    else
      @dom.classList.remove name

  addEventListener: (evt, callback, cascade)->
    @dom.addEventListener.apply( @dom, arguments)

  getBackgroundId: ()->
    if @dom.dataset && @dom.dataset.backgroundid
      @dom.dataset.backgroundid
    else if @dom.hasAttribute('data-backgroundid')
      @dom.getAttribute('data-backgroundid')
    else
      null


window.Slide = Slide

