#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super
    
    # Initialize controllers:
    @append(@goals = new App.Goals)
    @append(@entries = new App.Entries)
    @append(@targets = new App.Targets)
    #  ...
    
    Spine.Route.setup()    

window.App = App