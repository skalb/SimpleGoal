class SimpleGoal.Routers.TargetsRouter extends Backbone.Router
  initialize: (options) ->
    @targets = new SimpleGoal.Collections.TargetsCollection()
    @targets.reset options.targets

  routes:
    "/new"      : "newTarget"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newTarget: ->
    @view = new SimpleGoal.Views.Targets.NewView(collection: @targets)
    $("#targets").html(@view.render().el)

  index: ->
    @view = new SimpleGoal.Views.Targets.IndexView(targets: @targets)
    $("#targets").html(@view.render().el)

  show: (id) ->
    target = @targets.get(id)

    @view = new SimpleGoal.Views.Targets.ShowView(model: target)
    $("#targets").html(@view.render().el)

  edit: (id) ->
    target = @targets.get(id)

    @view = new SimpleGoal.Views.Targets.EditView(model: target)
    $("#targets").html(@view.render().el)
