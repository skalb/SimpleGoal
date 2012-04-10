SimpleGoal.Views.Goals ||= {}

class SimpleGoal.Views.Goals.NewView extends Backbone.View
  template: JST["backbone/templates/goals/new"]

  events:
    "submit #new-goal": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (goal) =>
        @model = goal
        window.location.hash = "/#{@model.id}"

      error: (goal, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
