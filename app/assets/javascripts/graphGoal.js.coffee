window.graphGoal = @graphGoal = (goal) -> 
  $('#main').append("<div id=\"chart\" style=\"height:#{document.height * .95}px; width:#{document.width * .95}px;\"></div>")

  targets = goal.targets().all()
  entries = goal.entries().all()

  if targets.length == 0 then getFirstTarget(goal) else drawEntries(goal, targets, entries)

@drawEntries = (goal, targets, entries) ->
  entryLine = entries.map (entry) -> 
    [ (new Date(entry.date)).getTime(), entry.value ]

  allValues = []
  for a in [targets, entries]
    for e in a
      allValues.push(e.value)

  yMax = Math.max allValues...

  yMax = Math.ceil(yMax * 1.1 / 10) * 10

  options = 
    title: goal.name
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
    targets = goal.targets().all()
    canvasOverlay.draw(plot)    

  App.Target.fetch(updateCanvas)

  canvasOverlay = plot.plugins.canvasOverlay;
  isDragging = false
  currentTargetLine = null
  currentCanvasLine = null
  $('#chart').bind "jqplotMouseDown", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1
      currentTargetLine = findClosestTargetLine(targets, pointIndex.yaxis)
      if currentTargetLine
        currentCanvasLine = canvasOverlay.get(currentTargetLine.value.toString());
        isDragging = true

  $('#chart').bind "jqplotMouseMove", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1 && isDragging
      currentCanvasLine.options.y = pointIndex.yaxis 
      currentTargetLine.value = pointIndex.yaxis
      canvasOverlay.draw(plot)

  $('#chart').bind "jqplotMouseUp", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 1 && isDragging
      isDragging = false
      canvasOverlay.objectNames = canvasOverlay.objectNames.filter (name) -> name != currentCanvasLine.options.name
      currentCanvasLine.options.name = currentTargetLine.value.toString()
      canvasOverlay.objectNames.push(currentTargetLine.value.toString())
      currentTargetLine.save()
      currentTargetLine.bind "save", -> 
        App.Target.fetch()

  $('#chart').bind "jqplotRightClick", (ev, seriesIndex, pointIndex, data) ->
    if ev.which == 3
      clickedTarget = findClosestTargetLine(targets, pointIndex.yaxis)
      if (clickedTarget)
        removeCanvasLine(canvasOverlay, clickedTarget.value.toString())
        clickedTarget.bind "destroy", ->
          App.Target.fetch()
        clickedTarget.destroy()
      else
        newTarget = new App.Target(
          goal_id: goal.id
          value: pointIndex.yaxis
        )
        newTarget.bind "save", ->
          canvasOverlay.addHorizontalLine(getHoriztonalLine(newTarget))
          App.Target.fetch()
        newTarget.save()

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
  name: target.value.toString()
  y: target.value
  lineWidth: 10
  color: "rgb(100, 55, 124)"
  shadow: true
  xOffset: 0  

@findClosestTargetLine = (targets, y) ->
  min = Number.MAX_VALUE
  for target in targets
    dist = Math.abs(target.value - y)
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
