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

    self = this
    do (self) ->
      self.collection.on("sync", (model, collection) ->
        self.model = model
        window.location.hash = "/#{self.model.id}"
      )
    @collection.create(@model.toJSON(),
      error: (goal, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
