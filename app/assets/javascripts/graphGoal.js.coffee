window.graphGoal = @graphGoal = (goal) -> 
  $('#main').append("<div id=\"chart\" style=\"height:#{$(document).height() * .90}px; width:#{$(document).width() * .90}px;\"></div>")

  targets = goal.targets.models
  entries = goal.entries.models

  if targets.length == 0 then getFirstTarget(goal) else drawEntries(goal, targets, entries)

@drawEntries = (goal, targets, entries) ->
  entryLine = entries.map (entry) -> 
    [ (new Date(entry.get("date"))).getTime(), entry.get("value") ]

  allValues = []
  for a in [targets, entries]
    for e in a
      allValues.push(e.attributes.value)

  yMax = Math.max allValues...

  yMax = Math.ceil(yMax * 1.1 / 10) * 10

  options = 
    axes:
      xaxis:
        renderer: $.jqplot.DateAxisRenderer
        tickOptions:
          formatString: "%b&nbsp;%#d"
      yaxis:
        min: 0
        max: yMax
        tickInterval: 10
        # tickOptions:
          # formatString: "%.2f"
    # highlighter:
    #   show: true
    #   sizeAdjust: 7.5
    # cursor:
    #   show: true
    noDataIndicator:
      show: true
      indicator: ''
    canvasOverlay:
      show: true
      objects: getHorizontalLines(targets)
    captureRightClick: true
  plot = $.jqplot("chart", [entryLine], options)

  updateCanvas = ->
    targets = goal.targets.models
    canvasOverlay.draw(plot)    

  canvasOverlay = plot.plugins.canvasOverlay;
  isDragging = false
  currentTargetLine = null
  currentCanvasLine = null

@removeCanvasLine = (canvasOverlay, targetValue) ->
  newObjects = []
  for line in canvasOverlay.objects
    if line.options.name != targetValue
      newObjects.push(line)
  canvasOverlay.objects = newObjects

@getHorizontalLines = (targets) ->
  horizontalLines = targets.map (target) -> 
    horizontalLine:
      getHoriztonalLine(target)

@getHoriztonalLine = (target) -> 
  name: target.get("value").toString()
  y: target.get("value")
  lineWidth: 10
  color: "rgb(100, 55, 124)"
  shadow: true
  xOffset: 0  

@getFirstTarget = (goal) ->
  $("#popupDialog").show().dialog
    modal: true
    autoOpen: true
    buttons:
      Accept: ->
        $(this).dialog "close"
        target = new SimpleGoal.Models.Target(
          value: $('#target').val()
          goal_id: goal.id
        )
        goal.targets.on "sync", ->
          goal.targets.fetch success: ->
            graphGoal(goal)
        goal.targets.create(target) 