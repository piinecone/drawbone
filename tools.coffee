class drawbone.views.Tools extends Backbone.View
  events:
    'click a[data-tool]' : 'onToolSelected'

  initialize: (options) ->
    @canvas = options.canvas
    @compositeCanvas = options.compositeCanvas
    @.on 'canvasEvent', @canvasEvent, @
    @initializeTools()
    @registerToolTriggers()
    @currentTool = @pencil

  displayDrawingTools: ->
    text = $("<a data-tool='text'>text</a>")
    text.appendTo @$el

  initializeTools: ->
    @pencil = new drawbone.tools.Pencil canvas: @canvas
    #@rectangle = new applesauce.views.CanvasRectangleTool canvas: @canvas
    #@line = new applesauce.views.CanvasLineTool canvas: @canvas
    #@text = new applesauce.views.CanvasTextTool canvas: @canvas
    #@eraser = new applesauce.views.CanvasEraserTool canvas: @compositeCanvas
    #@textInput = new applesauce.views.CanvasTextInputView

  render: ->
    @displayDrawingTools()
    @

  registerToolTriggers: ->
    @pencil.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @
    #@rectangle.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @
    #@line.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @
    #@eraser.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @
    #@text.on 'shouldDisplayTextInput', @shouldDisplayTextInput, @
    #@text.on 'toolDidCompleteDrawing', @toolDidCompleteDrawing, @
    #@textInput.on 'didEnterText', @toolDidEnterText, @

  onToolSelected: (event) ->
    selection = $(event.target).data('tool')
    @currentTool = @currentToolForSelection selection

  currentToolForSelection: (selection) ->
    switch selection
      when 'pencil' then @pencil
      #when 'rectangle' then @rectangle
      #when 'line' then @line
      #when 'text' then @text
      #when 'eraser' then @eraser

  toolDidCompleteDrawing: ->
    @.trigger 'toolDidCompleteDrawing'

  shouldDisplayTextInput: ->
    @textInput.render()

  toolDidEnterText: (text) ->
    @text.didEnterText text

  canvasEvent: (event) ->
    @currentTool[event.type] event
