window.graphGoal = @graphGoal = (goal) -> 
  $('#main').append("<div id=\"chart\" style=\"height:#{document.height * .95}px; width:#{document.width * .95}px;\"></div>")

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
    title: goal.attributes.name
    axes:
      xaxis:
        renderer: $.jqplot.DateAxisRenderer
        tickOptions:
          formatString: "%b&nbsp;%#d"
      yaxis:
        min: 0
        max: yMax
        tickInterval: yMax / 10
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
  $('#chart').bind "jqplotMouseDown", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1
      currentTargetLine = findClosestTargetLine(targets, pointIndex.yaxis)
      if currentTargetLine
        currentCanvasLine = canvasOverlay.get(currentTargetLine.get("value").toString());
        isDragging = true

  $('#chart').bind "jqplotMouseMove", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1 && isDragging
      currentCanvasLine.options.y = pointIndex.yaxis 
      currentTargetLine.set("value", pointIndex.yaxis)
      canvasOverlay.draw(plot)

  $('#chart').bind "jqplotMouseUp", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1 && isDragging
      isDragging = false
      canvasOverlay.objectNames = canvasOverlay.objectNames.filter (name) -> name != currentCanvasLine.options.name
      currentCanvasLine.options.name = currentTargetLine.get("value").toString()
      canvasOverlay.objectNames.push(currentTargetLine.get("value").toString())
      currentTargetLine.save()

  $('#chart').bind "jqplotRightClick", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 3
      clickedTarget = findClosestTargetLine(targets, pointIndex.yaxis)
      if (clickedTarget)
        removeCanvasLine(canvasOverlay, clickedTarget.get("value").toString())
        goal.targets.remove(clickedTarget)
        clickedTarget.destroy()
        canvasOverlay.draw(plot)
      else
        newTarget = new SimpleGoal.Models.Target(
          goal_id: goal.id
          value: pointIndex.yaxis
        )
        goal.targets.on "sync", ->
          canvasOverlay.addHorizontalLine(getHoriztonalLine(newTarget))
          canvasOverlay.draw(plot)
        goal.targets.create(newTarget)

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

@findClosestTargetLine = (targets, y) ->
  min = Number.MAX_VALUE
  for target in targets
    dist = Math.abs(target.get("value") - y)
    if (dist < min)
      min = dist
      minTarget = target

  if (min < 1.0) then return minTarget else return null

@getFirstTarget = (goal) ->
  $("#popupDialog").show().dialog
    modal: true
    autoOpen: true
    buttons:
      Cancel: ->
        $(this).dialog "close"
      Accept: ->
        $(this).dialog "close"
        target = new App.Target
          value: $('#target').val()
          date: $('#date').val()
          goal_id: goal.id
        target.save()
