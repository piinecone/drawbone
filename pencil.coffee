class drawbone.tools.Pencil extends Backbone.View
  initialize: (options) ->
    @canvas = options.canvas
    @context = @canvas.getContext '2d'
    @started = false

  render: ->
    @

  mousedown: (event) ->
    @context.beginPath()
    @context.moveTo event._x, event._y
    @started = true

  mousemove: (event) ->
    if @started
      @context.lineTo event._x, event._y
      @context.stroke()

  mouseup: (event) ->
    if @started
      @mousemove event
      @started = false
      @.trigger 'toolDidCompleteDrawing'
