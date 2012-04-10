SimpleGoal.Views.Goals ||= {}

class SimpleGoal.Views.Goals.IndexView extends Backbone.View
  template: JST["backbone/templates/goals/index"]

  initialize: () ->
    @options.goals.bind('reset', @addAll)

  addAll: () =>
    @options.goals.each(@addOne)

  addOne: (goal) =>
    view = new SimpleGoal.Views.Goals.GoalView({model : goal})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(goals: @options.goals.toJSON() ))
    @addAll()

    return this
