class SimpleGoal.Models.Target extends Backbone.Model
  paramRoot: 'target'

  defaults:
    value: null
    date: null
    goal_id: null

class SimpleGoal.Collections.TargetsCollection extends Backbone.Collection
  model: SimpleGoal.Models.Target
  url: '/targets'
