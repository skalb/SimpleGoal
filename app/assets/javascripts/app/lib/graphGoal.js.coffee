window.graphGoal = @graphGoal = (goal) -> 
  $('#main').append("<div id=\"chart\" style=\"height:#{document.height * .95}px; width:#{document.width * .95}px;\"></div>")

  targets = goal.targets().all()
  entries = goal.entries().all()

  if targets.length == 0 then getFirstTarget(goal) else drawEntries(goal, targets, entries)

  # line1 = [ [ "23-May-08", 578.55 ], [ "20-Jun-08", 566.5 ], [ "25-Jul-08", 480.88 ], [ "22-Aug-08", 509.84 ], [ "26-Sep-08", 454.13 ], [ "24-Oct-08", 379.75 ], [ "21-Nov-08", 303 ], [ "26-Dec-08", 308.56 ], [ "23-Jan-09", 299.14 ], [ "20-Feb-09", 346.51 ], [ "20-Mar-09", 325.99 ], [ "24-Apr-09", 386.15 ] ]

@drawEntries = (goal, targets, entries) ->
  entryLine = entries.map (entry) -> [ entry.date, entry.value ]

  index = 0
  horizontalLines = targets.map (target) -> 
    horizontalLine:
      name: "hl#{index}" 
      y: target.value
      lineWidth: 5
      color: "rgb(100, 55, 124)"
      shadow: true
      xOffset: 0 

  targetValues = targets.map (target) -> target.value
  yMax = Math.max targetValues...

  options = 
    title: goal.name
    axes:
      xaxis:
        renderer: $.jqplot.DateAxisRenderer
        tickOptions:
          formatString: "%b&nbsp;%#d"
      yaxis:
        min: 0
        max: yMax * 1.2
        tickInterval: yMax * .12 # * 1.2 / 10
        tickOptions:
          formatString: "%.2f"
    highlighter:
      show: true
      sizeAdjust: 7.5
    cursor:
      show: true
    noDataIndicator:
      show: true
    canvasOverlay:
      show: true
      objects: horizontalLines
  plot = $.jqplot("chart", [ entryLine ], options)

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
