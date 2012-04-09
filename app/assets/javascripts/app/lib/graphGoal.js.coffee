window.graphGoal = @graphGoal = (goal) -> 
  $('#main').append("<div id=\"chart\" style=\"height:#{document.height * .95}px; width:#{document.width * .95}px;\"></div>")

  targets = goal.targets().all()
  entries = goal.entries().all()

  if targets.length == 0 then getFirstTarget(goal) else drawEntries(goal, targets, entries)

@drawEntries = (goal, targets, entries) ->
  entryLine = entries.map (entry) -> [ window.formatDate(entry.date), entry.value ]

  horizontalLines = targets.map (target) -> 
    horizontalLine:
      name: target.id.toString()
      y: target.value
      lineWidth: 10
      color: "rgb(100, 55, 124)"
      shadow: true
      xOffset: 0 

  allValues = []
  for a in [targets, entries]
    for e in a
      allValues.push(e.value)

  yMax = Math.max allValues...

  yMax = Math.floor(yMax * 1.1 / 10) * 10

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
        tickInterval: Math.floor(yMax / 100) * 10
        tickOptions:
          formatString: "%.2f"
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
      objects: horizontalLines
  plot = $.jqplot("chart", [ entryLine ], options)

  canvasOverlay = null
  currentTargetLine = null
  currentCanvasLine = null
  $('#chart').bind "jqplotMouseDown", (ev, seriesIndex, pointIndex, data) ->
    currentTargetLine = findClosestTargetLine(targets, pointIndex.yaxis)
    canvasOverlay = plot.plugins.canvasOverlay;
    currentCanvasLine = canvasOverlay.get(currentTargetLine.id.toString());

  $('#chart').bind "jqplotMouseMove", (ev, seriesIndex, pointIndex, data) ->
    if currentTargetLine
      currentCanvasLine.options.y = pointIndex.yaxis 
      currentTargetLine.value = pointIndex.yaxis
      currentTargetLine.save()
      canvasOverlay.draw(plot);

  $('#chart').bind "jqplotMouseUp", (ev, seriesIndex, pointIndex, data) ->
    currentTargetLine = null

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
