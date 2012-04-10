SimpleGoal.Views.Entries ||= {}

class SimpleGoal.Views.Entries.ShowView extends Backbone.View
  template: JST["backbone/templates/entries/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
