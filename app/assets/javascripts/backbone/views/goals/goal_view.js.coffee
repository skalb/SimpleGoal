SimpleGoal.Views.Goals ||= {}

class SimpleGoal.Views.Goals.GoalView extends Backbone.View
  template: JST["backbone/templates/goals/goal"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
