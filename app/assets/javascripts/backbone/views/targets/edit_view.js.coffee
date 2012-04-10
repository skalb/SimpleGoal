SimpleGoal.Views.Targets ||= {}

class SimpleGoal.Views.Targets.EditView extends Backbone.View
  template : JST["backbone/templates/targets/edit"]

  events :
    "submit #edit-target" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (target) =>
        @model = target
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
