SimpleGoal.Views.Targets ||= {}

class SimpleGoal.Views.Targets.NewView extends Backbone.View
  template: JST["backbone/templates/targets/new"]

  events:
    "submit #new-target": "save"

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
      success: (target) =>
        @model = target
        window.location.hash = "/#{@model.id}"

      error: (target, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
