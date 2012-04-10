class SimpleGoal.Models.Entry extends Backbone.Model
  paramRoot: 'entry'

  defaults:
    value: null
    date: null
    goal_id: null

class SimpleGoal.Collections.EntriesCollection extends Backbone.Collection
  model: SimpleGoal.Models.Entry
  initialize: (models, args) ->
    @url = ->
      args.goal_url + "/entries"
