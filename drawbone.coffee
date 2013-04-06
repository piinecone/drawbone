window.drawbone =
  views: {}

class drawbone.views.Canvas extends Backbone.View
  initialize: (options) ->
    @initializeDom()
    @initializeEventHandlers()
    @initializeTools()
    @drawImage(options.image_url) if options? and options.image_url?

  render: ->
    @tools.render()
    @

  initializeEventHandlers: ->
    @temporaryCanvas.bind 'mousedown mousemove mouseup', @recordCanvasEvent, @

  initializeTools: ->
    @tools = new drawbone.views.Tools
      el: @toolbar
      canvas: @temporaryCanvas
      compositeCanvas: @compositeCanvas
    @tools.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @

  drawImage: (image_url) ->
    image = new Image()
    image.onload = =>
      @compositeContext = @compositeCanvas.getContext '2d'
      @compositeContext.drawImage image, 0, 0
    image.src = image_url

  clear: ->
    @compositeContext = @compositeCanvas.getContext '2d'
    @compositeContext.clearRect 0, 0, @compositeCanvas.width, @compositeCanvas.height

  initializeDom: ->
    id_root = @$el.attr('id')
    @toolbar = $("<div id='#{id_root}_drawbone_tools' />")
    @toolbar.appendTo @$el
    @drawTemporaryCanvas id_root
    @drawCompositeCanvas id_root

  drawTemporaryCanvas: (id) ->
    @temporaryCanvas = $("<canvas />")
    @temporaryCanvas.attr 'id', "#{id}_temporary_canvas"
    # TODO set dimensions, etc
    @temporaryCanvas.appendTo @$el

  drawCompositeCanvas: (id) ->
    @compositeCanvas = $("<canvas />")
    @compositeCanvas.attr 'id', "#{id}_composite_canvas"
    # TODO set dimensions, etc
    @compositeCanvas.appendTo @$el

  drawingToolSelected: (selection) ->
    @selectedTool = selection

  toolDidCompleteDrawing: ->
    @compositeContext = @compositeCanvas.getContext '2d'
    @temporaryContext = @temporaryCanvas.getContext '2d'
    @compositeContext.drawImage @temporaryCanvas, 0, 0
    @temporaryContext.clearRect 0, 0, @temporaryCanvas.width, @temporaryCanvas.height

  recordCanvasEvent: (event) ->
    if event.layerX || event.layerX == 0 # firefox
      event._x = event.layerX
      event._y = event.layerY
    else if event.offsetX || event.offsetX == 0 # opera
      event._x = event.offsetX
      event._y = event.offsetY

    @tools.trigger 'canvasEvent', event
