SimpleGoal.Views.Goals ||= {}

class SimpleGoal.Views.Goals.ShowView extends Backbone.View
  template: JST["backbone/templates/goals/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
