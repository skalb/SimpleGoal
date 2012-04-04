#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super
    
    # Initialize controllers:
    @append(@goals = new App.Goals)
    #  ...
    
    Spine.Route.setup()    

window.App = App